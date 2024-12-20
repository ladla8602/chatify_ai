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
