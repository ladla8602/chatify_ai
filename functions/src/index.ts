// The Firebase Admin SDK to access Firestore.
import { initializeApp } from "firebase-admin/app";
// import { getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
// import { getAuth } from "firebase-admin/auth";

initializeApp();
// const db = getFirestore();

// Middleware function to validate Firebase ID token
// const validateAuthToken = async (req: any, res: any, next: any) => {
//   const idToken = req.headers.authorization?.split('Bearer ')[1];

//   if (!idToken) {
//     res.status(401).send("Authorization token is required");
//     return;
//   }

//   try {
//     const decodedToken = await getAuth().verifyIdToken(idToken);
//     req.user = decodedToken; // Attach user info to request
//     next(); // Proceed to the next handler
//   } catch (error) {
//     res.status(403).send("Unauthorized access");
//   }
// };

// export const askChatGPT = onRequest((req: any, res) => {
//   logger.info("Ask ChatGPT", { structuredData: true });
//   validateAuthToken(req, res, () => {
//     const user = req.user;
//     logger.info("Authenticated user:", { uid: user.uid });

//     // Process the request, e.g., interact with ChatGPT, and respond
//     res.send(`Hello, ${user.uid}. You can now ask ChatGPT!`);
//   });
// });

export const askChatGPT2 = onCall(async (request) => {
  logger.info(process.env.OPENAI_API_KEY, { structuredData: true });

  // Check if the request is authenticated
  if (!request.auth) {
    throw new Error("Authentication required");
  }

  // Access the authenticated user
  const user = request.auth;
  logger.info("Authenticated user:", { uid: user.uid });

  // Process the request, e.g., interact with ChatGPT, and respond
  return `Hello, ${user.uid}. You can now ask ChatGPT!`;
});