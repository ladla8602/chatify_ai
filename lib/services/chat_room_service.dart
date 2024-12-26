import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new chat room for the user
  Future<String?> createChatRoom() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in.");
      return null;
    }

    // Check if a chat room already exists for this user
    final existingChatRoom = await _firestore
        .collection('chats')
        .where('userIds',
            arrayContains:
                user.uid) // Assuming 'userIds' stores the users in the chat
        .limit(1)
        .get();

    if (existingChatRoom.docs.isNotEmpty) {
      // If an existing chat room is found, return its ID
      return existingChatRoom.docs.first.id;
    }

    // If no existing chat room is found, create a new one
    String chatRoomId =
        "chat_${user.uid}_${DateTime.now().millisecondsSinceEpoch}";

    // Create a new chat room document in Firestore with the user's ID
    await _firestore.collection('chats').doc(chatRoomId).set({
      'createdBy': user.uid,
      'userIds': [user.uid], // Store the user ID in the 'userIds' field
      'createdAt': Timestamp.now(),
    });

    return chatRoomId;
  }

  // Fetch all chat rooms of a user
  Stream<QuerySnapshot> getUserChatRooms() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    return _firestore
        .collection('chats')
        .where('createdBy', isEqualTo: user.uid)
        .snapshots();
  }
}
