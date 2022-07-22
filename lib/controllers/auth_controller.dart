import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import 'package:tiktokclone/models/user.dart' as model;

import '../constants.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<File?> _pickedImage; // Foundation class used for custom Types outside
  // the common native Dart types.
  late Rx<User?> _user;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    // first time app loads up
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen); // ever Called every time listener changes.
    // As long as the condition returns true
  }

  _setInitialScreen(User? user) {
    if (user == null) { // if user is NOT logged in then to login screen
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen()); // else show home screen directly
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar(
          'Profile Picture', "you have successfully selected your pic");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // Upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // if this is the case we need to save the user in firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            name: username,
            profilePhoto: downloadUrl,
            email: email,
            uid: cred.user!.uid);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Error Creating account', 'Please enter all credentials');
      }
    } catch (e) {
      Get.snackbar("error creating account", e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("Logged in");
      } else {
        Get.snackbar('Error Loging In', 'Please enter all credentials');
      }
    } catch (e) {
      Get.snackbar("error creating account", e.toString());
    }

    }
    void signOut() async{
      await firebaseAuth.signOut();
  }
}
