import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tiktokclone/controllers/auth_controller.dart';
import 'package:tiktokclone/views/screens/login_screen.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
        options:const FirebaseOptions(
            apiKey: "AIzaSyAULMVtQeM9yQi_oFxLws4S56lC2y8qDKo",
            authDomain: "tiktoktutorial-9d891.firebaseapp.com",
            projectId: "tiktoktutorial-9d891",
            storageBucket: "tiktoktutorial-9d891.appspot.com",
            messagingSenderId: "1010290652295",
            appId: "1:1010290652295:web:f6c30a693adaa63c163422",
            measurementId: "G-QD3VGCFTNR"
        )).then((value) => {Get.put(AuthController())});
  } else {
    await Firebase.initializeApp().then((value) => {Get.put(AuthController())});
  }
  runApp(const TicTocMain());
}

class TicTocMain extends StatelessWidget {
  const TicTocMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TikToK Demo",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: LoginScreen(),
    );
  }
}
