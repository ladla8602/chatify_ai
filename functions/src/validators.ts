import { TextToSpeechRequest } from "./types";

// validators.ts
export class RequestValidator {
  /**
   * Validate a message to ensure it is not empty and does not exceed 4000
   * characters.
   *
   * @throws {Error} If the message is empty or exceeds maximum length.
   * @return {string} Trimmed message.
   */
  static validateMessage(message: unknown): string {
    if (!message || typeof message !== "string" || !message.trim()) {
      throw new Error("Message cannot be empty");
    }

    if (message.length > 4000) {
      throw new Error("Message exceeds maximum length of 4000 characters");
    }

    return message.trim();
  }

  static validateTextToSpeech(params: TextToSpeechRequest) {
    if (!params.text) {
      throw new Error("Text is required");
    }
    if (params.text.length > 4096) {
      throw new Error("Text exceeds maximum length of 4096 characters");
    }
    if (params.voice && !["alloy", "echo", "fable", "onyx", "nova", "shimmer"].includes(params.voice)) {
      throw new Error("Invalid voice option");
    }
    if (params.model && !["tts-1", "tts-1-hd"].includes(params.model)) {
      throw new Error("Invalid model option");
    }
    if (params.format && !["mp3", "opus", "aac", "flac"].includes(params.format)) {
      throw new Error("Invalid format option");
    }
    return params;
  }
}
