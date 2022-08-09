
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/tinder_swipe/create_group_activity.dart';
import 'package:tiktokclone/unused/home_swipe.dart';
import 'package:tiktokclone/views/screens/add_video_screen.dart';
import 'package:tiktokclone/views/screens/profile_screen.dart';
import 'package:tiktokclone/views/screens/search_screen.dart';
import 'package:tiktokclone/views/screens/tryoutScreen.dart';
import 'package:tiktokclone/views/screens/video_screen.dart';
import 'controllers/auth_controller.dart';

  List pages = [
  VideoScreen(),
    SearchScreen(),
  const AddVideoScreen(),
  GroupActivity(),
  ProfileScreen(uid: authController.user.uid),

];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// Firebase related constants
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// Controller
var authController = AuthController.instance;
