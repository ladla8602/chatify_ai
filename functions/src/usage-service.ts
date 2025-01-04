import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { UserData } from './types';

export class UsageService {
  private static async getUserData(userId: string): Promise<UserData> {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userId)
      .get();

    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    const userData = userDoc.data();
    const now = admin.firestore.Timestamp.now();
    return {
      subscription: {
        status: 'inactive',
        endDate: now,
        ...userData?.subscription
      },
      usage: {
        daily: {},
        monthly: {},
        ...userData?.usage
      },
      limits: {
        messagesPerDay: 5,
        messagesPerMonth: 100,
        imagesPerDay: 2,
        imagesPerMonth: 20,
        audiosPerDay: 2,
        audiosPerMonth: 20,
        ...userData?.limits
      },
      ...userData
    } as UserData;
  }

  private static async checkSubscription(userId: string): Promise<UserData> {
    const userData = await this.getUserData(userId);
    const now = admin.firestore.Timestamp.now();

    if (userData.subscription.status !== 'active' ||
      userData.subscription.endDate.seconds < now.seconds) {
      throw new functions.https.HttpsError('permission-denied', 'Subscription inactive');
    }

    return userData;
  }

  private static async checkLimits(
    type: 'message' | 'image' | 'audio',
    userData: UserData
  ): Promise<void> {
    const today = new Date().toISOString().split('T')[0];
    const currentMonth = today.substring(0, 7);

    const dailyUsage = userData.usage?.daily?.[today]?.[`${type}sCount`] || 0;
    const monthlyUsage = userData.usage?.monthly?.[currentMonth]?.[`${type}sCount`] || 0;

    if (dailyUsage >= userData.limits[`${type}sPerDay`]) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Daily ${type} limit reached`
      );
    }

    if (monthlyUsage >= userData.limits[`${type}sPerMonth`]) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Monthly ${type} limit reached`
      );
    }
  }

  public static async incrementUsage(
    userId: string,
    type: 'message' | 'image' | 'audio'
  ): Promise<void> {
    const today = new Date().toISOString().split('T')[0];
    const currentMonth = today.substring(0, 7);
    const userRef = admin.firestore().collection('users').doc(userId);

    try {
      await admin.firestore().runTransaction(async (transaction) => {
        const userData = await this.checkSubscription(userId);
        await this.checkLimits(type, userData);

        transaction.set(userRef, {
          usage: {
            daily: {
              [today]: {
                [`${type}sCount`]: admin.firestore.FieldValue.increment(1),
                lastUpdated: admin.firestore.FieldValue.serverTimestamp()
              }
            },
            monthly: {
              [currentMonth]: {
                [`${type}sCount`]: admin.firestore.FieldValue.increment(1),
                lastUpdated: admin.firestore.FieldValue.serverTimestamp()
              }
            }
          }
        }, { merge: true });
      });
    } catch (error) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        'internal',
        'Failed to increment usage'
      );
    }
  }
}