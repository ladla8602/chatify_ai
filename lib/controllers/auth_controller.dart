import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var checkbox = false.obs;
  var passwordVisible = false.obs;
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

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  bool get isLoggedIn => firebaseUser.value != null;

  String get initialRoute {
    return isLoggedIn ? AppRoutes.chatview : AppRoutes.login;
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      isLoading.value = true;
      // Create the user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? firebaseUser = userCredential.user;
      // Optionally save additional user data to Firestore
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'lastLogin': DateTime.now(),
        });

        Get.snackbar("Success", "Account created successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorConstant.primaryColor,
            colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", "Failed to sign in: $e");
    } finally {
      isLoading.value = false; // Hide loader
    }
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

  Future<void> _createUserInFirestore(User? firebaseUser) async {
    try {
      if (firebaseUser == null) {
        throw Exception("Firebase user is null");
      }

      // Ensure the data is available
      String uid = firebaseUser.uid;
      String email = firebaseUser.email ?? 'No email';
      String? displayName = firebaseUser.displayName ?? 'No name';
      String? photoUrl = firebaseUser.photoURL ?? 'No photo URL';

      // Create or update the user in Firestore
      final usersCollection =
          _firestore.collection(AppConstant.usersCollection);
      await usersCollection.doc(uid).set({
        'uid': uid,
        'email': email,
        'name': displayName,
        'photoUrl': photoUrl,
        'lastLogin': DateTime.now(),
      });

      print("User added to Firestore with uid: $uid");
    } catch (e) {
      // Log any errors for debugging
      print("Error creating user in Firestore: $e");
      Get.snackbar("Error", "Failed to create user in Firestore: $e");
    }
  }
}
