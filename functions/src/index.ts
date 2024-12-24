// The Firebase Admin SDK to access Firestore.
import { initializeApp } from "firebase-admin/app";
// import { getFirestore } from "firebase-admin/firestore";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

initializeApp();
// const db = getFirestore();

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", { structuredData: true });
  response.send(process.env.OPENAI_API_KEY);
});
