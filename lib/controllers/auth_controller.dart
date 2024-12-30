import 'package:chatify_ai/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import '../views/common/dialog_wigets.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool checkbox = false.obs;
  RxBool passwordVisible = false.obs;
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
    return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
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
        Locale? deviceLocale = Get.locale ?? Get.deviceLocale;
        UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName ?? 'Anonymous',
          email: firebaseUser.email ?? 'N/A',
          photoURL: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
          settings: UserSettings(
            notifications: true,
            phoneLanguage: deviceLocale?.languageCode ?? 'unknown',
            countryCode: deviceLocale?.countryCode ?? 'unknown',
          ),
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel.toFirestore());

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

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showCustomDialog(
        context,
        title: 'Log in\nSuccessful!',
        icon: HugeIcons.strokeRoundedUserCircle02,
        message: ' Please wait...\nYou will be directed to the homepage ',
        widget: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: 5,
          color: Theme.of(context).primaryColor,
        ),
      );
      await Future.delayed(const Duration(seconds: 4));
      Navigator.pop(context);
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar("Error", "Failed to sign in: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Hide loader
    }
  }

  // Future<void> loginWithGoogle() async {
  //   try {
  //     isLoading.value = true;

  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       isLoading.value = false;
  //       return; // User canceled the login
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     final User? firebaseUser = userCredential.user;

  //     // Save firebaseUser data to Firestore
  //     final usersCollection =
  //         _firestore.collection(AppConstant.usersCollection);
  //     await usersCollection.doc(firebaseUser?.uid).set({
  //       'uid': firebaseUser?.uid,
  //       'name': firebaseUser?.displayName,
  //       'email': firebaseUser?.email,
  //       'photoUrl': firebaseUser?.photoURL,
  //       'lastLogin': DateTime.now(),
  //     });

  //     Get.snackbar("Success", "Logged in successfully",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Theme.of(context).primaryColor,
  //         colorText: Colors.white);
  //     Get.toNamed(AppRoutes.chatview);
  //   } catch (e) {
  //     Get.printError(info: e.toString());
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
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

      // Check if user already exists in Firestore
      final docSnapshot = await _firestore
          .collection(AppConstant.usersCollection)
          .doc(firebaseUser?.uid)
          .get();

      if (!docSnapshot.exists) {
        // New Google user -> Create in Firestore
        await _createUserInFirestore(firebaseUser);

        // Navigate to password setup screen
        Get.offNamed(AppRoutes.setPassword, arguments: firebaseUser);
      } else {
        Get.snackbar("Success", "Logged in as ${firebaseUser?.displayName}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorConstant.primaryColor,
            colorText: Colors.white);

        Get.offNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      Get.printError(info: e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPasswordForGoogleUser(String password) async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found");
      }

      final email = user.email;
      if (email == null) {
        throw Exception("Google user has no email");
      }

      // Reauthenticate the user before updating
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: await user.getIdToken(),
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(password);
      Get.snackbar("Success", "Password set successfully");
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar("Error", "Failed to set password: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    Get.offNamed(AppRoutes.login);
  }

  Future<void> _createUserInFirestore(User? firebaseUser) async {
    try {
      if (firebaseUser == null) {
        throw Exception("Firebase user is null");
      }

      final usersCollection =
          _firestore.collection(AppConstant.usersCollection);
      final userDoc = usersCollection.doc(firebaseUser.uid);

      // Merge user data
      await userDoc.set({
        'uid': firebaseUser.uid,
        'email': firebaseUser.email ?? '',
        'name': firebaseUser.displayName ?? '',
        'photoUrl': firebaseUser.photoURL ?? '',
        'lastLogin': DateTime.now(),
      }, SetOptions(merge: true)); // Merge with existing data
    } catch (e) {
      print("Error creating user in Firestore: $e");
      Get.snackbar("Error", "Failed to save user data: $e");
    }
  }
}
