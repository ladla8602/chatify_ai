export interface ChatRequest {
  message: string;
}

export interface ChatResponse {
  success: boolean;
  message?: string;
  error?: string;
  timestamp: string;
}


export interface ImageGenerateRequest {
  prompt: string;
  model: string;
  quantity: number;
  size: "256x256" | "512x512" | "1024x1024" | "1792x1024" | "1024x1792" | null | undefined;
  style?: "vivid" | "natural" | null;
}

export interface ImageGenerateResponse {
  success: boolean;
  image?: string;
  error?: string;
  timestamp: string;
}


interface Usage {
  messagesCount: number;
  imagesCount: number;
  audiosCount: number;
  lastUpdated: FirebaseFirestore.Timestamp;
}

export interface UserData {
  subscription: {
    planId: string;
    status: string;
    endDate: FirebaseFirestore.Timestamp;
  };
  limits: {
    messagesPerDay: number;
    imagesPerDay: number;
    audiosPerDay: number;
    messagesPerMonth: number;
    imagesPerMonth: number;
    audiosPerMonth: number;
  };
  usage: {
    daily: {
      [key: string]: Usage;
    };
    monthly: {
      [key: string]: Usage;
    };
  };
}