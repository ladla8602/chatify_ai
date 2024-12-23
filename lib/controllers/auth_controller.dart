import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var checkbox = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observable User
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  void toggleCheckbox(bool? value) {
    checkbox.value = value ?? false;
    update();
  }

  bool get isLoggedIn => firebaseUser.value != null;

  String get initialRoute {
    return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User canceled the login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      // Save firebaseUser data to Firestore
      final usersCollection =
          _firestore.collection(AppConstant.usersCollection);
      await usersCollection.doc(firebaseUser?.uid).set({
        'uid': firebaseUser?.uid,
        'name': firebaseUser?.displayName,
        'email': firebaseUser?.email,
        'photoUrl': firebaseUser?.photoURL,
        'lastLogin': DateTime.now(),
      });

      Get.snackbar("Success", "Logged in as ${_auth.currentUser?.displayName}");
    } catch (e) {
      Get.printError(info: e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
