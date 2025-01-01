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
  style?: 'vivid' | 'natural' | null;
}

export interface ImageGenerateResponse {
  success: boolean;
  image?: string;
  error?: string;
  timestamp: string;
}