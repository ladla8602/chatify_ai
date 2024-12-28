export interface ChatRequest {
  message: string;
}

export interface ChatResponse {
  success: boolean;
  message?: string;
  error?: string;
  timestamp: string;
}
