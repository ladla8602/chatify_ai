// index.ts
import { initializeApp } from "firebase-admin/app";
import * as functions from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { OpenAIService } from "./openai-service.js";
// import { AuthService } from "./auth-service.js";
import { config } from "dotenv";
import type { ChatRequest, ChatResponse, ImageGenerateRequest, ImageGenerateResponse, Message, TextToSpeechRequest, TextToSpeechResponse } from "./types.js";
import { RequestValidator } from "./validators.js";
// import { getAuth, ListUsersResult } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import Stripe from "stripe";
import { LangChainService } from "./langchain.service.js";
import { HandleStripeWebhook } from "./stripe.webhook.js";
import { UsageService } from "./usage-service.js";

// Load environment variables
config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
if (!OPENAI_API_KEY) {
  throw new Error("OPENAI_API_KEY environment variable is required");
}

const STRIPE_SECRET_KEY = process.env.STRIPE_SECRET_KEY;
if (!STRIPE_SECRET_KEY) {
  throw new Error("STRIPE_SECRET_KEY environment variable is required");
}

const STRIPE_WEBHOOK_SECRET = process.env.STRIPE_WEBHOOK_SECRET;
if (!STRIPE_WEBHOOK_SECRET) {
  throw new Error("STRIPE_WEBHOOK_SECRET environment variable is required");
}

const stripe = new Stripe(STRIPE_SECRET_KEY);
// Set emulator before initializing
// process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";

// Initialize Firebase Admin
initializeApp();
const db = getFirestore();
UsageService.initialize(db);

export const askChatGPT = onCall<ChatRequest, Promise<ChatResponse>>({
  maxInstances: 2,
  timeoutSeconds: 120,
  memory: "512MiB",
}, async (request) => {
  try {
    const { auth } = request;

    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    // Validate request
    const message = RequestValidator.validateMessage(request.data.message);
    // Get OpenAI service instance
    // const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);
    const langchainService = await LangChainService.getInstance(request.data.provider || "deepseek");
    // Generate response with timeout
    const timeoutPromise = new Promise<string>((_, reject) =>
      setTimeout(() => reject(new Error("Request timeout")), 25000)
    );

    // Prepare messages
    const messages: Message[] = [
      { role: "assistant", content: request.data.chatbot?.botPrompt || "You are a helpful assistant." },
      { role: "user", content: message },
    ];
    // Generate response
    const response = await Promise.race<string>([
      // openAIService.generateCompletion(message),
      langchainService.generateCompletion(messages),
      timeoutPromise,
    ]);

    await UsageService.incrementUsage(auth.uid, "message");

    return {
      success: true,
      message: response,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    functions.logger.error("Error in askChatGPT:", error);
    // Return error response
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});

export const generateAIImage = onCall<ImageGenerateRequest, Promise<ImageGenerateResponse>>({
  maxInstances: 2,
  timeoutSeconds: 120,
  memory: "512MiB",
}, async (request) => {
  try {
    const { auth } = request;
    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }
    await UsageService.incrementUsage(auth.uid, "image");
    // Get OpenAI service instance
    const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);
    // Generate response with timeout
    const timeoutPromise = new Promise<string>((_, reject) =>
      setTimeout(() => reject(new Error("Request timeout")), 25000)
    );
    // Generate response
    const response = await Promise.race<string>([
      openAIService.generateImage(request.data),
      timeoutPromise,
    ]);

    return {
      success: true,
      image: response,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    functions.logger.error("Error in generateAIImage:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});

export const generateSpeech = onCall<TextToSpeechRequest, Promise<TextToSpeechResponse>>({
  maxInstances: 2,
  timeoutSeconds: 120,
  memory: "512MiB",
}, async (request) => {
  try {
    const { auth } = request;

    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    await UsageService.incrementUsage(auth.uid, "audio");

    // Validate request
    const params = RequestValidator.validateTextToSpeech(request.data);

    // Get OpenAI service instance
    const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);

    // Generate response with timeout
    const timeoutPromise = new Promise<string>((_, reject) =>
      setTimeout(() => reject(new Error("Request timeout")), 25000)
    );

    // Generate speech
    const audioUrl = await Promise.race<string>([
      openAIService.generateSpeech(params),
      timeoutPromise,
    ]);

    return {
      success: true,
      audioUrl: audioUrl,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    functions.logger.error("Error in generateSpeech:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});

// WEB RTC
export const getVoiceChatToken = onCall({
  maxInstances: 3,
  timeoutSeconds: 120,
  memory: "512MiB",
}, async (request) => {
  try {
    const { auth } = request;
    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);

    const ephemeralKey = await openAIService.generateEphemeralKey(request.data);

    return {
      success: true,
      token: ephemeralKey,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    functions.logger.error("Error generating voice chat token:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
    };
  }
});

export const getSubscriptionPlans = onCall(
  async (request) => {
    const { auth } = request;
    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    try {
      // Retrieve active products with prices from Stripe
      const products = await stripe.products.list({
        active: true,
        expand: ["data.default_price"],
        type: "service",
      });

      // Filter and format plans
      const plans = products.data
        .filter((product) => product.metadata.subscription_plan === "true") // Optional filter
        .map((product) => ({
          id: product.id,
          name: product.name,
          description: product.description,
          marketing_features: product.marketing_features,
          metadata: product.metadata,
          price: {
            id: (product.default_price as Stripe.Price)?.id,
            currency: (product.default_price as Stripe.Price)?.currency,
            unit_amount: (product.default_price as Stripe.Price)?.unit_amount,
            recurring: (product.default_price as Stripe.Price)?.recurring,
          },
        }));

      return { plans: plans };
    } catch (error) {
      functions.logger.error("Error getSubscriptionPlans:", error);
      return {
        success: false,
        error: error instanceof Error ? error.message : "An unexpected error occurred",
      };
    }
  }
);

// Create Customer in Stripe
export const createStripeCustomer = onCall(async (request) => {
  const { auth } = request;
  if (!auth || !auth.uid) {
    throw new Error("Authentication required");
  }

  try {
    // const userDoc = db.collection('users').doc(auth.uid);
    // const userSnapshot = await userDoc.get();

    // // Check for existing Stripe customer ID
    // if (userSnapshot.exists) {
    //   const existingCustomerId = userSnapshot.data()?.stripeCustomerId;
    //   if (existingCustomerId) {
    //     return { customerId: existingCustomerId };
    //   }
    // }

    const customer = await stripe.customers.create({
      email: auth.token.email,
      name: auth.token.name,
      metadata: {
        firebaseUid: auth.uid,
      },
    },
    {
      idempotencyKey: auth.uid, // Ensure idempotency
    },
    );

    // Save Stripe Customer ID to Firestore
    await db
      .collection("users")
      .doc(auth.uid)
      .set({
        stripeCustomerId: customer.id,
      }, { merge: true });

    return { customerId: customer.id };
  } catch (error) {
    functions.logger.error("Error createStripeCustomer:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
    };
  }
});

// Create Subscription
export const createSubscription = onCall(async (request) => {
  const { auth } = request;
  if (!auth || !auth.uid) {
    throw new Error("Authentication required");
  }

  const { priceId } = request.data;
  const user = await db
    .collection("users")
    .doc(auth.uid)
    .get();

  let stripeCustomerId = user.data()?.stripeCustomerId;

  if (!stripeCustomerId) {
    const customer = await stripe.customers.create({
      email: auth.token.email,
      name: auth.token.name,
      metadata: {
        firebaseUid: auth.uid,
      },
    },
    {
      idempotencyKey: auth.uid, // Ensure idempotency
    },
    );
    stripeCustomerId = customer.id;
    await db
      .collection("users")
      .doc(auth.uid)
      .set({
        stripeCustomerId: customer.id,
      });
  }

  try {
    const subscription = await stripe.subscriptions.create({
      customer: stripeCustomerId,
      items: [{ price: priceId }],
      payment_behavior: "default_incomplete",
      expand: ["latest_invoice.payment_intent"],
    });

    // Type-safe access to expanded properties
    const latestInvoice = subscription.latest_invoice as Stripe.Invoice | null;
    const paymentIntent = latestInvoice?.payment_intent as Stripe.PaymentIntent | null;

    if (!paymentIntent?.client_secret) {
      throw new Error("Failed to retrieve payment intent client secret");
    }

    return {
      subscriptionId: subscription.id,
      clientSecret: paymentIntent?.client_secret,
    };
  } catch (error) {
    functions.logger.error("Error createSubscription:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred. Cannot create subscription.",
    };
  }
});

export const stripeWebhook = functions.https.onRequest(
  async (request: functions.https.Request, response: any) => {
    const sig = request.headers["stripe-signature"] as string;

    // Webhook secret from Stripe Dashboard
    const webhookSecret = STRIPE_WEBHOOK_SECRET;

    // Important: Configure the cloud function to handle raw body
    const { rawBody } = request;

    if (!rawBody) {
      console.error("No raw body found in request");
      return response.status(400).send("Webhook Error: No raw body");
    }

    let event: Stripe.Event;

    try {
      // Verify webhook signature for security
      event = stripe.webhooks.constructEvent(
        rawBody,
        sig,
        webhookSecret
      );
    } catch (err) {
      console.error("Webhook signature verification failed", err);
      return response.status(400).send(`Webhook Error: ${err}`);
    }
    try {
      // Handle different subscription events
      const stripeWebhookHandler = new HandleStripeWebhook(db);
      await stripeWebhookHandler.handleEvent(event);

      // Send 200 response to acknowledge receipt of the event
      response.json({ received: true });
    } catch (err) {
      console.error("Error processing webhook:", err);
      return response.status(500).send(`Webhook processing failed: ${err instanceof Error ? err.message : "Unknown error"}`);
    }
  });
