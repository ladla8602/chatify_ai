import { AIMessage, BaseMessage, HumanMessage, SystemMessage } from "@langchain/core/messages";
import { ChatDeepSeek } from "@langchain/deepseek";
import { ChatGoogleGenerativeAI } from "@langchain/google-genai";
import { ChatOpenAI } from "@langchain/openai";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import OpenAI from "openai";
import { ImageGenerateRequest, Message, ModelConfiguration, ModelsSettings, TextToSpeechRequest, WebRTCTokenRequest, WebRTCTokenResponse } from "./types";

export class LangChainService {
  private llm: ChatOpenAI | ChatGoogleGenerativeAI | ChatDeepSeek;
  private static instance: LangChainService;
  private static apiKeys: { [key: string]: string } = {};
  private static modelSettings: ModelsSettings;
  private static provider: string;

  /**
   * Creates an instance of the LangChainService.
   * Note that this is a private constructor, and instances should be
   * obtained using the getInstance static method.
   * @param provider The LLM provider to use (e.g., "openai", "gemini", "deepseek").
   */
  private constructor(customProvider = "openai") {
    LangChainService.provider = customProvider;
    const apiKey = LangChainService.apiKeys[LangChainService.provider];
    if (!apiKey) {
      throw new Error(`No API key found for provider: ${LangChainService.provider}`);
    }

    switch (LangChainService.provider) {
    case "gemini":
      this.llm = new ChatGoogleGenerativeAI({ apiKey, model: "gemini-1.5-flash" });
      break;
    case "deepseek":
      this.llm = new ChatDeepSeek({ apiKey, model: "deepseek-chat" });
      break;
    case "openai":
    default:
      this.llm = new ChatOpenAI({ openAIApiKey: apiKey, temperature: 0.7 });
      break;
    }
  }

  /**
   * Gets the default model configuration for a specific service type
   */
  private static getDefaultModel(serviceType: keyof ModelsSettings): ModelConfiguration {
    const settings = LangChainService.modelSettings[serviceType];
    const provider = LangChainService.provider as keyof typeof settings.defaultModels;
    const defaultModelId = settings.defaultModels[provider];
    const defaultModel = settings.configurations.find(
      (config) => config.id === defaultModelId && config.isActive && config.provider === LangChainService.provider
    );

    if (!defaultModel) {
      throw new Error(`This model seems to be inactive ${serviceType}. Please contact admin.`);
    }
    console.log(`Default model for ${serviceType}:`, defaultModel);

    return defaultModel;
  }

  /**
   * Gets an instance of the LangChainService.
   * If an instance does not already exist, one is created with the given provider.
   * @param provider The LLM provider to use (e.g., "openai", "gemini", "deepseek").
   * @return An instance of the LangChainService.
   */
  static async getInstance(provider = "openai"): Promise<LangChainService> {
    await LangChainService.loadSettings();
    // if (!LangChainService.instance) {
    //   await LangChainService.loadSettings();
    //   LangChainService.instance = new LangChainService(provider);
    // }
    LangChainService.instance = new LangChainService(provider);
    return LangChainService.instance;
  }

  /**
   * Loads API keys and model settings from Firestore appSettings collection
   */
  private static async loadSettings(): Promise<void> {
    const db = getFirestore();
    const settingsDoc = await db.collection("appSettings").doc("settings").get();

    if (!settingsDoc.exists) {
      throw new Error("Settings document not found in Firestore");
    }

    const data = settingsDoc.data();
    if (!data) {
      throw new Error("Settings document is empty");
    }

    LangChainService.apiKeys = data.apiKeys;
    LangChainService.modelSettings = data.models;
  }

  /**
   * Generates a completion response using LangChain's LLMChain
   * based on the given user message.
   *
   * @param message - The user input message to generate a response for.
   * @return A promise that resolves to a string containing the generated response.
   * @throws An error if no response is generated.
   */
  async generateCompletion(messages: Message[]): Promise<string> {
    if (!messages?.length) {
      throw new Error("Messages array is required");
    }
    const langChainMessages: BaseMessage[] = messages.map((msg) => {
      switch (msg.role) {
      case "system":
        return new SystemMessage(msg.content);
      case "user":
        return new HumanMessage(msg.content);
      case "assistant":
        return new AIMessage(msg.content);
      default:
        throw new Error(`Invalid message role: ${msg.role}`);
      }
    });

    try {
      this.llm.model = LangChainService.getDefaultModel("chat").apiModel;
      const response = await this.llm.invoke(langChainMessages);

      if (!response?.content) {
        throw new Error("Invalid response from LLM");
      }

      return response.content.toString();
    } catch (error) {
      console.error("Error generating completion:", error);
      throw error;
    }
  }

  async generateImage(payload: ImageGenerateRequest): Promise<any> {
    // Image generation is not directly supported by LangChain, so you may need to use the original provider's API.
    // For OpenAI, you can still use the original OpenAI client for image generation.
    const defaultModel = LangChainService.getDefaultModel("imageGeneration");
    const openai = new OpenAI({ apiKey: LangChainService.apiKeys["openai"] });
    const response = await openai.images.generate({
      model: payload.model || defaultModel.apiModel,
      prompt: payload.prompt,
      n: payload.quantity ?? 1,
      size: payload.size,
      response_format: "url",
      style: payload.style,
    });
    if (!response) {
      throw new Error("No response generated");
    }

    return response.data[0].url;
  }

  async generateSpeech(params: TextToSpeechRequest): Promise<string> {
    try {
      const defaultModel = LangChainService.getDefaultModel("textToVoice");
      const openai = new OpenAI({ apiKey: LangChainService.apiKeys["openai"] });
      const response = await openai.audio.speech.create({
        model: params.model || defaultModel.apiModel,
        voice: params.voice || "alloy",
        input: params.text,
        response_format: params.format || "mp3",
      });
      if (!response) {
        throw new Error("No response generated");
      }
      const audioData = await response.arrayBuffer();
      const audioBuffer = Buffer.from(audioData);

      const bucket = getStorage().bucket();
      const fileName = `audio/${Date.now()}.${params.format || "mp3"}`;
      const file = bucket.file(fileName);

      await file.save(audioBuffer, {
        metadata: { contentType: `audio/${params.format || "mp3"}` },
      });

      await file.makePublic();

      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
      return publicUrl;
    } catch (error) {
      throw new Error(`Failed to generate speech: ${error instanceof Error ? error.message : "Unknown error"}`);
    }
  }

  async generateEphemeralKey(request?: WebRTCTokenRequest): Promise<WebRTCTokenResponse> {
    try {
      const requestBody = {
        model: request?.model || "gpt-4o-realtime-preview-2024-12-17",
        voice: request?.voice || "verse",
      };

      const response = await fetch("https://api.openai.com/v1/realtime/sessions", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${LangChainService.apiKeys["openai"]}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
      });

      const responseText = await response.json();

      if (!response.ok) {
        console.error("OpenAI API Error Response:", responseText);
        throw new Error(`API request failed: ${response.status} - ${responseText}`);
      }

      const data = responseText;
      return {
        token: data.client_secret.value,
        expires_at: data.expires_at,
      };
    } catch (error) {
      console.error("Error generating ephemeral key:", error);
      throw new Error(`Failed to generate ephemeral key: ${error instanceof Error ? error.message : "Unknown error"}`);
    }
  }
}
