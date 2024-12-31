import 'package:chatify_ai/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService() : _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatbots() async {
    return await _firestore.collection(FirebasePaths.chatBots).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRoomMessages(String chatRoomId, [DocumentSnapshot? startAfter]) async {
    Query<Map<String, dynamic>> query = _firestore.collection(FirebasePaths.chatRoomMessages(chatRoomId));
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return await query.limit(10).get();
  }
}
