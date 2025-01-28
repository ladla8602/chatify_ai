// import * as admin from "firebase-admin";
// import * as functions from "firebase-functions";
// import { UserData } from "./types";

// export class UsageService {
//   private static async getUserData(userId: string): Promise<UserData> {
//     const userDoc = await admin.firestore()
//       .collection("users")
//       .doc(userId)
//       .get();

//     if (!userDoc.exists) {
//       throw new functions.https.HttpsError("not-found", "User not found");
//     }

//     const userData = userDoc.data();
//     const now = admin.firestore.Timestamp.now();
//     return {
//       subscription: {
//         status: "inactive",
//         endDate: now,
//         ...userData?.subscription,
//       },
//       usage: {
//         daily: {},
//         monthly: {},
//         ...userData?.usage,
//       },
//       limits: {
//         messagesPerDay: 5,
//         messagesPerMonth: 100,
//         imagesPerDay: 2,
//         imagesPerMonth: 20,
//         audiosPerDay: 2,
//         audiosPerMonth: 20,
//         ...userData?.limits,
//       },
//       ...userData,
//     } as UserData;
//   }

//   private static async checkSubscription(userId: string): Promise<UserData> {
//     const userData = await this.getUserData(userId);
//     const now = admin.firestore.Timestamp.now();

//     if (userData.subscription.status !== "active" ||
//       userData.subscription.endDate.seconds < now.seconds) {
//       throw new functions.https.HttpsError("permission-denied", "Subscription inactive");
//     }

//     return userData;
//   }

//   private static async checkLimits(
//     type: "message" | "image" | "audio",
//     userData: UserData
//   ): Promise<void> {
//     const today = new Date().toISOString().split("T")[0];
//     const currentMonth = today.substring(0, 7);

//     const dailyUsage = userData.usage?.daily?.[today]?.[`${type}sCount`] || 0;
//     const monthlyUsage = userData.usage?.monthly?.[currentMonth]?.[`${type}sCount`] || 0;

//     if (dailyUsage >= userData.limits[`${type}sPerDay`]) {
//       throw new functions.https.HttpsError(
//         "resource-exhausted",
//         `Daily ${type} limit reached`
//       );
//     }

//     if (monthlyUsage >= userData.limits[`${type}sPerMonth`]) {
//       throw new functions.https.HttpsError(
//         "resource-exhausted",
//         `Monthly ${type} limit reached`
//       );
//     }
//   }

//   public static async incrementUsage(
//     userId: string,
//     type: "message" | "image" | "audio"
//   ): Promise<void> {
//     const today = new Date().toISOString().split("T")[0];
//     const currentMonth = today.substring(0, 7);
//     const userRef = admin.firestore().collection("users").doc(userId);

//     try {
//       await admin.firestore().runTransaction(async (transaction) => {
//         const userData = await this.checkSubscription(userId);
//         await this.checkLimits(type, userData);

//         transaction.set(userRef, {
//           usage: {
//             daily: {
//               [today]: {
//                 [`${type}sCount`]: admin.firestore.FieldValue.increment(1),
//                 lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
//               },
//             },
//             monthly: {
//               [currentMonth]: {
//                 [`${type}sCount`]: admin.firestore.FieldValue.increment(1),
//                 lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
//               },
//             },
//           },
//         }, { merge: true });
//       });
//     } catch (error) {
//       if (error instanceof functions.https.HttpsError) {
//         throw error;
//       }
//       throw new functions.https.HttpsError(
//         "internal",
//         "Failed to increment usage"
//       );
//     }
//   }
// }
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { Firestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions";

interface UserData {
  subscription: {
    status: "active" | "inactive";
    endDate: admin.firestore.Timestamp;
  };
  usage: {
    daily: Record<string, any>;
    monthly: Record<string, any>;
  };
  limits: {
    messagesPerDay: number;
    messagesPerMonth: number;
    imagesPerDay: number;
    imagesPerMonth: number;
    audiosPerDay: number;
    audiosPerMonth: number;
  };
}

export class UsageService {
  private static db: Firestore;

  static initialize(database?: Firestore) {
    try {
      if (database) {
        this.db = database;
      } else if (!this.db) {
        // Log the initialization attempt
        logger.info("Initializing Firestore in UsageService");
        this.db = admin.firestore();
      }
      // Verify initialization
      if (!this.db) {
        throw new Error("Failed to initialize Firestore");
      }
    } catch (error) {
      logger.error("Error initializing UsageService:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to initialize database connection"
      );
    }
  }

  private static async getUserData(userId: string): Promise<UserData> {
    try {
      logger.info(`Fetching user data for userId: ${userId}`);

      if (!this.db) {
        logger.error("Firestore not initialized in getUserData");
        throw new Error("Database not initialized");
      }

      const userDoc = await this.db
        .collection("users")
        .doc(userId)
        .get();

      if (!userDoc.exists) {
        logger.info(`Creating new user document for userId: ${userId}`);
        const defaultData = {
          subscription: {
            status: "active", // Changed to active for testing
            endDate: admin.firestore.Timestamp.fromDate(
              new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) // 30 days from now
            ),
          },
          usage: {
            daily: {},
            monthly: {},
          },
          limits: {
            messagesPerDay: 50,
            messagesPerMonth: 1000,
            imagesPerDay: 20,
            imagesPerMonth: 200,
            audiosPerDay: 20,
            audiosPerMonth: 200,
          },
        };

        await this.db
          .collection("users")
          .doc(userId)
          .set(defaultData);

        return defaultData as UserData;
      }

      logger.info(`User data found for userId: ${userId}`);
      return userDoc.data() as UserData;
    } catch (error) {
      logger.error("Error in getUserData:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to fetch user data"
      );
    }
  }

  public static async incrementUsage(
    userId: string,
    type: "message" | "image" | "audio"
  ): Promise<void> {
    try {
      logger.info(`Starting incrementUsage for userId: ${userId}, type: ${type}`);

      if (!this.db) {
        this.initialize();
      }

      const today = new Date().toISOString().split("T")[0];
      const currentMonth = today.substring(0, 7);
      const userRef = this.db.collection("users").doc(userId);

      // First, verify the document exists
      const userDoc = await userRef.get();
      if (!userDoc.exists) {
        logger.info(`Creating new user document for userId: ${userId}`);
        await this.getUserData(userId); // This will create the document if it doesn't exist
      }

      await this.db.runTransaction(async (transaction) => {
        logger.info(`Starting transaction for userId: ${userId}`);

        const updateData = {
          [`usage.daily.${today}.${type}sCount`]: FieldValue.increment(1),
          [`usage.daily.${today}.lastUpdated`]: FieldValue.serverTimestamp(),
          [`usage.monthly.${currentMonth}.${type}sCount`]: FieldValue.increment(1),
          [`usage.monthly.${currentMonth}.lastUpdated`]: FieldValue.serverTimestamp(),
        };

        // Log the update data for debugging
        logger.info("Update data:", JSON.stringify(updateData));

        // Update the document
        transaction.update(userRef, updateData);

        logger.info(`Transaction completed successfully for userId: ${userId}`);
      });

      logger.info(`Successfully incremented usage for userId: ${userId}`);
    } catch (error) {
      // Log the full error
      logger.error("Detailed error in incrementUsage:", error);

      // Handle specific error types
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }

      if (error instanceof Error) {
        throw new functions.https.HttpsError(
          "internal",
          `Failed to update usage: ${error.message}`
        );
      }

      throw new functions.https.HttpsError(
        "internal",
        "An unexpected error occurred while updating usage limits"
      );
    }
  }

  // Utility method for debugging
  public static async debugUserData(userId: string): Promise<any> {
    try {
      const userDoc = await this.db.collection("users").doc(userId).get();
      return {
        exists: userDoc.exists,
        data: userDoc.data(),
      };
    } catch (error) {
      logger.error("Error in debugUserData:", error);
      throw error;
    }
  }
}
