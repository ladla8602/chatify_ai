import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastActive;
  final UserSettings settings;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoURL,
    required this.createdAt,
    required this.lastActive,
    required this.settings,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'lastActive': lastActive,
      'settings': settings.toMap(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'settings': settings.toFirestore(),
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      settings: UserSettings.fromMap(data['settings'] ?? {}),
    );
  }

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastActive,
    UserSettings? settings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
    );
  }
}

class UserSettings {
  final bool notifications;
  final String phoneLanguage;
  final String countryCode;

  UserSettings({
    required this.notifications,
    required this.phoneLanguage,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications,
      'phoneLanguage': phoneLanguage,
      'countryCode': countryCode,
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      notifications: map['notifications'] ?? true,
      phoneLanguage: map['phoneLanguage'] ?? 'unknown',
      countryCode: map['countryCode'] ?? 'unknown',
    );
  }
}
