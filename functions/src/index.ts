// index.ts
import { onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import { OpenAIService } from "./openai-service.js";
// import { AuthService } from "./auth-service.js";
import { RequestValidator } from "./validators.js";
import type { ChatRequest, ChatResponse } from "./types.js";
import { config } from "dotenv";
import { getAuth, ListUsersResult } from "firebase-admin/auth";

// Load environment variables
config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
if (!OPENAI_API_KEY) {
  throw new Error("OPENAI_API_KEY environment variable is required");
}

// Set emulator before initializing
// process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";

// Initialize Firebase Admin
initializeApp();

export const askChatGPT = onCall<ChatRequest, Promise<ChatResponse>>({
  maxInstances: 2,
  timeoutSeconds: 30,
  memory: "128MiB",
}, async (request) => {
  try {
    const { auth } = request;

    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }
    // Validate request
    const message = RequestValidator.validateMessage(request.data.message);

    // Log request
    logger.info("Processing request", {
      uid: request.auth?.uid,
      messageLength: message.length,
      timestamp: new Date().toISOString(),
    });

    // Get OpenAI service instance
    const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);

    // Generate response with timeout
    const timeoutPromise = new Promise<string>((_, reject) =>
      setTimeout(() => reject(new Error("Request timeout")), 25000)
    );

    const response = await Promise.race<string>([
      openAIService.generateCompletion(message),
      timeoutPromise,
    ]);

    // Log success
    logger.info("Request successful", {
      uid: request.auth?.uid,
      responseLength: response.length,
    });

    return {
      success: true,
      message: response,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    // Log error
    logger.error("Error in askChatGPT:", {
      error: error instanceof Error ? {
        message: error.message,
        stack: error.stack,
        name: error.name,
      } : "Unknown error",
      uid: request.auth?.uid,
      timestamp: new Date().toISOString(),
    });

    // Return error response
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});

export const getUsers = onCall(async (request) => {
  try {
    const { auth } = request;

    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    // Only allow admin users
    const user = await getAuth().getUser(request.auth?.uid || "");
    // const isAdmin = user.customClaims?.isAdmin === true;

    if (!user || user.email !== process.env.ADMIN_EMAIL) {
      throw new Error("Unauthorized access");
    }

    const users = [];
    let pageToken;
    do {
      const result: ListUsersResult = await getAuth().listUsers(1000, pageToken);
      users.push(...result.users);
      pageToken = result.pageToken;
    } while (pageToken);

    return {
      success: true,
      users: users.map((user) => ({
        uid: user.uid,
        email: user.email,
        image: user.photoURL,
        emailVerified: user.emailVerified,
        displayName: user.displayName,
        createdAt: user.metadata.creationTime,
      })),
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    logger.error("Error in getUsers:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});
