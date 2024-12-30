import 'package:chatify_ai/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService() : _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatbots() async {
    return await _firestore.collection(FirebasePaths.chatBots).get();
  }
}
