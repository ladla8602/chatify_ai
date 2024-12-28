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
}
