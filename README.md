# chatify_ai

A new Flutter project.

## Getting Started

Flutter SDK used: 3.27.4

## Flutter commands

```dart
flutter pub get --no-example
dart run intl_utils:generate
```

```dart
adb shell setprop debug.firebase.analytics.app com.fastlab.chatify_ai
```

- Production APK Build:

```dart
flutter build apk --release --no-tree-shake-icons
flutter build appbundle --release --no-tree-shake-icons
```
# Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/e41db2fa-2617-4581-a299-1303972d3a61" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/4526e009-0a29-4fe7-95a7-1d75749a343a" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/7a4d1b72-9a02-4afb-a613-751b8e5d5c85" width="auto"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/3e76b2a5-bbfa-4a72-a6c4-8748e7b0c52d" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/09533155-b765-47b3-9e4f-40251c8415e7" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/aefaec18-69d3-450a-8028-ff3a96d8c641" width="auto"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/06c1df3e-2ebd-44b4-8cb9-41c2125c415f" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/600a77c6-ef7d-4508-ac51-33a4fc245128" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/334bcc3f-639b-4af6-9a70-d67a6a1e1402" width="auto"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/7a32a1b2-5177-44a3-8849-1d691ca7408d" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/13204759-f986-4f59-924c-80e2e5a261d7" width="auto"></td>
    <td><img src="https://github.com/user-attachments/assets/4476a0fe-11d5-43cc-95ad-0ed558c44005" width="auto"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/4a85b46e-735c-462a-961d-8d84e3fe0548" width="auto"></td>
  </tr>
</table>


# Setup Firebase

## 1. Package Name (Application ID) change for Android

Add project into your firebase account and add android, ios and web app with your `application id`. My appication id is `com.fastlab.chatify_ai` for adnroid. You also need to change this in current project as well. Here is the step you can follow to change application id:

- Step 1: Search `com.fastlab.chatify_ai` in whole project and replace every instance with your application id say its `com.yourcompany.myapp`.
- Step 2: Rename this folder name android\app\src\main\kotlin\com\\`fastlab\chatify_ai` to android\app\src\main\kotlin\com\\`yourcompany\myapp`

Well done you your android package name(applicaton id) is changed to `com.yourcompany.myapp`.

## 2. Use flutterfire CLI to setup firebase configuration in your project

Follow this doc - https://firebase.google.com/docs/flutter/setup?platform=android

## 3. Firebase functions

firebase emulators:start --import ./firebase-export-1738494335036oJP5Y8 --export-on-exit

firebase deploy --only functions:stripeWebhook

firebase functions:delete myFunction

## Stripe

### Subscription Testing Cards

https://docs.stripe.com/india-recurring-payments?integration=paymentIntents-setupIntents&testing-method=card-numbers#testing

stripe listen --forward-to http://127.0.0.1:5001/chatifyai-7a694/us-central1/stripeWebhook

## 4. Firestore Database Design

`users` Collection

```js
users/{userId}
{
  uid: string,          // Firebase Auth UID
  displayName: string,
  email: string,
  photoURL: string?,
  createdAt: timestamp,
  lastActive: timestamp,
  settings: {
    notifications: boolean,
    phoneLanguage: string,
    countryCode: string
  }
  subscriptionId: string,
  usage: {
    daily: {
      [date: string]: {  // Format: "YYYY-MM-DD"
        messagesCount: number,
        imagesCount: number,
        audiosCount: number,
        lastUpdated: timestamp
      }
    },
    monthly: {
      [month: string]: { // Format: "YYYY-MM"
        messagesCount: number,
        imagesCount: number,
        audiosCount: number,
        lastUpdated: timestamp
      }
    }
  },
  limits: {
    messagesPerDay: number,
    imagesPerDay: number,
    messagesPerMonth: number,
    imagesPerMonth: number
  }
}
```

`subscriptions` Collection

```js
subscription/{subscriptionId} {
    planId: string,
    status: string,      // "active", "cancelled", "expired"
    userId: string,
    startDate: timestamp,
    endDate: timestamp,
    platform: string,    // "google_play"
    purchaseToken: string,
    orderId: string
  }
```

`plans` Collection

```js
// plans collection for subscription tiers
plans/{planId} {
  name: string,
  price: number,
  currency: string,
  interval: string,     // "month" or "year"
  playStoreProductId: string,
  limits: {
    messagesPerDay: number,
    imagesPerDay: number,
    audioPerday: number,
    messagesPerMonth: number,
    imagesPerMonth: number,
    audioPerMonth: number,
  }
}

```

`chatBots` Collection

```js
chatBots/[botId]
{
  botName: string,
  botAvatar: string,
  botRole: string,
  botMessage: string,
  botPrompt: string,
  botStatus: sring,  // active, inactive
  createdAt: timestamp,
  userId: string, // Only meant for admin
}
```

`chatRooms` Collection

```js
chatRooms/{chatRoomId}
{
  userId: string,       // Reference to user who owns this chat
  botId: string,        // Identifier for the AI bot
  botName: string,
  createdAt: timestamp,
  lastMessage: {
    content: string,
    timestamp: timestamp,
    senderId: string    // Either userId or botId
  },
  metadata: {
    customInstructions: string?
  }
}
```

`messages` Collection (Subcollection of chatRooms)

```js
chatRooms/{chatRoomId}/messages/{messageId}
{
  content: string,
  timestamp: timestamp,
  senderId: string,     // Either userId or botId
  senderType: string,   // 'user' or 'bot'
  status: string,       // 'sent', 'delivered', 'error'
  type: string,         // 'text', 'image', 'system'
  metadata: {
    tokens: number?,    // For tracking token usage
    model: string?,     // AI model used
    error: string?      // Error message if status is 'error'
  }
}
```

`generatedImages` Collection

```js
generatedImages/{generatedImageId}
{
  userId: string,
  imgUrl: string,
  createdAt: timestamp,
  metadata: {
    prompt: string,
    model: string,
    size: string,
    quality: string,
  }
}
```

`appSetting` Collection

```js
{
  "settings": {
    "version": "1.0",
    "apiKeys": {
      "openai": "sk-...",
      "deepseek": "ds-...",
      "gemini": "gem-..."
    },
    "models": {
      "chat": {
        "configurations": [
          {
            "id": "gpt-4",
            "name": "GPT-4",
            "provider": "openai",
            "apiModel": "gpt-4-turbo-preview",
            "maxTokens": 128000,
            "isDefault": true,
            "isActive": true,
            "capabilities": {
              "streaming": true,
              "functionCalling": true,
              "imageAnalysis": true
            }
          }
          // More chat models...
        ],
        "defaultModelId": "gpt-4"
      },
      "voiceAssistant": {
        "configurations": [
          // Voice assistant models...
        ],
        "defaultModelId": "whisper-1"
      },
      "imageGeneration": {
        "configurations": [
          // Image generation models...
        ],
        "defaultModelId": "dall-e-3"
      },
      "textToVoice": {
        "configurations": [
          // Text to voice models...
        ],
        "defaultModelId": "elevenlabs-1"
      }
    },
    "rateLimit": {
      "requestsPerMinute": 60,
      "requestsPerDay": 1000
    },
    "maintenance": {
      "isUnderMaintenance": false
    }
  }
}
```
