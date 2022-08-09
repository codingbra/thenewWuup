import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiktokclone/controllers/search_controller.dart';
import 'package:tiktokclone/models/user.dart';
import 'package:tiktokclone/tinder_swipe/create_group_activity.dart';
import 'package:tiktokclone/views/screens/profile_screen.dart';



class SwipeSearchScreen extends StatelessWidget {
  static List<String> friendsChosen= [];

  SwipeSearchScreen({Key? key}) : super(key: key);

  final SearchController swipeSearchController = Get.put(SearchController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: const InputDecoration(
                filled: false,
                hintText: "Search for someone",
                hintStyle: TextStyle(fontSize: 18, color: Colors.white)),
            onFieldSubmitted: (value) => swipeSearchController.searchUser(value),
          ),
        ),
        body: swipeSearchController.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  "Search for user",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: swipeSearchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = swipeSearchController.searchedUsers[index];
                  return InkWell(
                    onTap: () async{
                      friendsChosen.add(user.name);
                      print(friendsChosen);
                      _firestore.collection("groups").add(
                          {"friends": friendsChosen});
                      },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                  );
                }),
      );
    });
  }
}
