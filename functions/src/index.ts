// index.ts
import { initializeApp } from "firebase-admin/app";
import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { OpenAIService } from "./openai-service.js";
// import { AuthService } from "./auth-service.js";
import { config } from "dotenv";
import type { ChatRequest, ChatResponse, ImageGenerateRequest, ImageGenerateResponse, Message, TextToSpeechRequest, TextToSpeechResponse } from "./types.js";
import { RequestValidator } from "./validators.js";
// import { getAuth, ListUsersResult } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import { LangChainService } from "./langchain.service.js";
import { UsageService } from "./usage-service.js";

// Load environment variables
config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
if (!OPENAI_API_KEY) {
  throw new Error("OPENAI_API_KEY environment variable is required");
}

// Set emulator before initializing
process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";

// Initialize Firebase Admin
initializeApp();
const db = getFirestore();
UsageService.initialize(db);

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
      { role: "assistant", content: request.data.chatBot.botPrompt || "You are a helpful assistant." },
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
    logger.error("Error in generateSpeech:", error);
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
  memory: "256MiB",
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
    logger.error("Error generating voice chat token:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "An unexpected error occurred",
    };
  }
});
