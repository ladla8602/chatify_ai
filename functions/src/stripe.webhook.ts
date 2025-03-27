import { Firestore } from "firebase-admin/firestore";
import Stripe from "stripe";

/**
 * HandleStripeWebhook class manages Stripe webhook events and updates Firebase accordingly.
 * This class handles subscription lifecycle events and payment processing.
 */
export class HandleStripeWebhook {
  private db: Firestore;

  constructor(db: Firestore) {
    this.db = db;
  }

  /**
   * Main event handler that routes different Stripe events to their specific handlers
   * @param event The incoming Stripe webhook event
   */
  async handleEvent(event: Stripe.Event): Promise<void> {
    try {
      switch (event.type) {
      case "customer.subscription.created":
        await this.handleSubscriptionCreated(event.data.object as Stripe.Subscription);
        break;
      case "customer.subscription.updated":
        await this.handleSubscriptionUpdated(event.data.object as Stripe.Subscription);
        break;
      case "customer.subscription.deleted":
        await this.handleSubscriptionCancelled(event.data.object as Stripe.Subscription);
        break;
      case "invoice.payment_succeeded":
        await this.handlePaymentSuccess(event.data.object as Stripe.Invoice);
        break;
      case "invoice.payment_failed":
        await this.handlePaymentFailure(event.data.object as Stripe.Invoice);
        break;
      default:
        console.log(`Unhandled event type: ${event.type}`);
      }
    } catch (error) {
      console.error("Error processing Stripe webhook:", error);
      throw new Error(`Failed to handle event: ${error instanceof Error ? error.message : "Unknown error"}`);
    }
  }

  /**
   * Handles new subscription creation
   * @param subscription The Stripe subscription object
   */
  private async handleSubscriptionCreated(subscription: Stripe.Subscription): Promise<void> {
    const userId = subscription.metadata.firebaseUid;
    if (!userId) {
      throw new Error("No Firebase UID found in subscription metadata");
    }

    await this.db
      .collection("users")
      .doc(userId)
      .update({
        subscriptionId: subscription.id,
        subscriptionStatus: "active",
        currentPeriodEnd: new Date(subscription.current_period_end * 1000), // Convert UNIX timestamp to Date
      });
  }

  /**
   * Handles subscription updates
   * @param subscription The Stripe subscription object
   */
  private async handleSubscriptionUpdated(subscription: Stripe.Subscription): Promise<void> {
    const userId = subscription.metadata.firebaseUid;
    if (!userId) {
      throw new Error("No Firebase UID found in subscription metadata");
    }

    await this.db
      .collection("users")
      .doc(userId)
      .update({
        subscriptionStatus: subscription.status,
        currentPeriodEnd: new Date(subscription.current_period_end * 1000),
      });
  }

  /**
   * Handles subscription cancellations
   * @param subscription The Stripe subscription object
   */
  private async handleSubscriptionCancelled(subscription: Stripe.Subscription): Promise<void> {
    const userId = subscription.metadata.firebaseUid;
    if (!userId) {
      throw new Error("No Firebase UID found in subscription metadata");
    }

    await this.db
      .collection("users")
      .doc(userId)
      .update({
        subscriptionStatus: "cancelled",
        subscriptionId: null,
        currentPeriodEnd: null,
      });
  }

  /**
   * Handles successful payments
   * @param invoice The Stripe invoice object
   */
  private async handlePaymentSuccess(invoice: Stripe.Invoice): Promise<void> {
    const userId = invoice.metadata?.firebaseUid;
    if (!userId) {
      throw new Error("No Firebase UID found in invoice metadata");
    }

    await this.db
      .collection("payments")
      .add({
        userId,
        amount: invoice.amount_paid,
        currency: invoice.currency,
        invoiceId: invoice.id,
        timestamp: new Date(),
        status: "succeeded",
      });
  }

  /**
   * Handles failed payments
   * @param invoice The Stripe invoice object
   */
  private async handlePaymentFailure(invoice: Stripe.Invoice): Promise<void> {
    const userId = invoice.metadata?.firebaseUid;
    if (!userId) {
      throw new Error("No Firebase UID found in invoice metadata");
    }

    await Promise.all([
      // Update user subscription status
      this.db
        .collection("users")
        .doc(userId)
        .update({
          subscriptionStatus: "past_due",
        }),

      // Record the failed payment
      this.db
        .collection("payments")
        .add({
          userId,
          amount: invoice.amount_due,
          currency: invoice.currency,
          invoiceId: invoice.id,
          timestamp: new Date(),
          status: "failed",
        }),
    ]);
  }
}
