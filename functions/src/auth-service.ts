// auth-service.ts
import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions";
import { AuthData } from "firebase-functions/tasks";

export class AuthService {
  /**
   * Verifies the authentication token provided in the request.
   *
   * @param auth - The authentication object containing the token to be
   * verified.
   *
   * @throws Will throw an error if the authentication object is not
   *  provided or if the token is invalid.
   *
   * Note: Skips token verification when running in the emulator environment.
   */
  static async verifyAuth(auth: AuthData | undefined): Promise<void> {
    if (!auth) {
      throw new Error("Authentication required");
    }

    if (process.env.FUNCTIONS_EMULATOR === "true") {
      logger.info("Skipping token verification in emulator");
      return;
    }

    try {
      logger.info("Verifying authentication token:", auth.token);
      await getAuth().verifyIdToken(auth.token.toString());
    } catch (error) {
      logger.error("Token verification failed:", error);
      throw new Error("Invalid authentication token");
    }
  }
}
