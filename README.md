# chatify_ai

A new Flutter project.

## Getting Started

Flutter SDK used: 3.27.1

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

# Setup Firebase

## 1. Package Name (Application ID) change for Android

Add project into your firebase account and add android, ios and web app with your `application id`. My appication id is `com.fastlab.chatify_ai` for adnroid. You also need to change this in current project as well. Here is the step you can follow to change application id:

- Step 1: Search `com.fastlab.chatify_ai` in whole project and replace every instance with your application id say its `com.yourcompany.myapp`.
- Step 2: Rename this folder name android\app\src\main\kotlin\com\\`fastlab\chatify_ai` to android\app\src\main\kotlin\com\\`yourcompany\myapp`

Well done you your android package name(applicaton id) is changed to `com.yourcompany.myapp`.

## 2. Use flutterfire CLI to setup firebase configuration in your project

Follow this doc - https://firebase.google.com/docs/flutter/setup?platform=android

## 3. Firebase functions

firebase emulators:start --import ./firebase-export-17353920669909mXqhx --export-on-exit

firebase functions:delete myFunction

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
