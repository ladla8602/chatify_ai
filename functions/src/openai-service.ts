// openai-service.ts
import OpenAI from "openai";
import { ImageGenerateRequest } from "./types";

export class OpenAIService {
  private client: OpenAI;
  private static instance: OpenAIService;

  /**
   * Creates an instance of the OpenAIService with the given API key.
   * Note that this is a private constructor, and instances should be
   * obtained using the getInstance static method.
   * @param apiKey The OpenAI API key to use for requests.
   */
  private constructor(apiKey: string) {
    this.client = new OpenAI({ apiKey });
  }

  /**
   * Gets an instance of the OpenAIService.
   * If an instance does not already exist, one is created with the given API key.
   * @param apiKey The OpenAI API key to use for requests.
   * @return An instance of the OpenAIService.
   */
  static getInstance(apiKey: string): OpenAIService {
    if (!OpenAIService.instance) {
      OpenAIService.instance = new OpenAIService(apiKey);
    }
    return OpenAIService.instance;
  }


  /**
   * Generates a completion response from the OpenAI API
   * based on the given user message. Utilizes the
   * "gpt-4o-mini-2024-07-18" model with specified
   * parameters for token limit,
   * temperature, presence penalty, and frequency penalty.
   *
   * @param message - The user input message to generate a
   * response for.
   * @return A promise that resolves to a string containing the
   * generated response.
   * @throws An error if no response is generated.
   */
  async generateCompletion(message: string): Promise<string> {
    const completion = await this.client.chat.completions.create({
      messages: [{ role: "user", content: message }],
      model: "gpt-4o-mini-2024-07-18",
      max_tokens: 1000,
      temperature: 0.7,
      presence_penalty: 0.6,
      frequency_penalty: 0.5,
    });

    const response = completion.choices[0]?.message?.content;
    if (!response) {
      throw new Error("No response generated");
    }

    return response;
  }

  async generateImage(payload: ImageGenerateRequest): Promise<any> {
    const response = await this.client.images.generate({
      model: payload.model,
      prompt: payload.prompt,
      n: payload.quantity ?? 1,
      size: payload.size,
      response_format: "url",
      style: payload.style,
    });
    if (!response) {
      throw new Error("No response generated");
    }
    console.log(response.data);
    return response.data[0].url;
  }
}
