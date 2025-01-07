// index.ts
import { onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import { OpenAIService } from "./openai-service.js";
// import { AuthService } from "./auth-service.js";
import { RequestValidator } from "./validators.js";
import type { ChatRequest, ChatResponse, ImageGenerateRequest, ImageGenerateResponse, TextToSpeechRequest, TextToSpeechResponse } from "./types.js";
import { config } from "dotenv";
// import { getAuth, ListUsersResult } from "firebase-admin/auth";
import { UsageService } from './usage-service.js';

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
  timeoutSeconds: 120,
  memory: "128MiB",
}, async (request) => {
  try {
    const { auth } = request;

    if (!auth || !auth.uid) {
      throw new Error("Authentication required");
    }

    await UsageService.incrementUsage(auth.uid, 'message');
    // Validate request
    const message = RequestValidator.validateMessage(request.data.message);
    // Get OpenAI service instance
    const openAIService = OpenAIService.getInstance(OPENAI_API_KEY);
    // Generate response with timeout
    const timeoutPromise = new Promise<string>((_, reject) =>
      setTimeout(() => reject(new Error("Request timeout")), 25000)
    );
    // Generate response
    const response = await Promise.race<string>([
      openAIService.generateCompletion(message),
      timeoutPromise,
    ]);

    return {
      success: true,
      message: response,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    logger.error("Error in askChatGPT:", error);
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
  memory: "128MiB",
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
    logger.error("Error in generateAIImage:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});


// audio generated///
export const generateSpeech = onCall<TextToSpeechRequest, Promise<TextToSpeechResponse>>({
  maxInstances: 2,
  timeoutSeconds: 120,
  memory: "256MiB",
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
    const audioBase64 = await Promise.race<string>([
      openAIService.generateSpeech(params),
      timeoutPromise,
    ]);

    return {
      success: true,
      audioUrl: `data:audio/${params.format || "mp3"};base64,${audioBase64}`,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    logger.error("Error in generateSpeech:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      timestamp: new Date().toISOString(),
    };
  }
});
