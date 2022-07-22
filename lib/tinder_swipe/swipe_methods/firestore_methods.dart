import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/models/groupActivity.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
class FirestoreMethods extends GetxController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // upload post
  Future<String> createGroup(String location, String uid, String username,
      String groupName, String date, List<String> friends,List<String> friendsChosenUid
      ,String hasVoted,List<String> chosenActivities, List<String> votedForReal) async {
    // has voted should be list // chosen activities should be map with no of likes

    String res = "Some error ocurred";
    try {
      GroupActivityPackage groupActivity = GroupActivityPackage(
          date: date, // sets the date the activity should take place
          location: location, // place the activity should take place
          friends: friends, // with whom you want to participate
          uid: uid, // for internal saving uid of creator
          username: username, // for external saving see who has invited
          datePublished: DateTime.now(), // to do - should be shorter
          groupName: groupName, // what the group shall be called
          friendsChosenUid:  friendsChosenUid,//for looping when friend chooses
          hasVoted: hasVoted, // sets who has voted on the activity --> how to access as friend?
          chosenActivities : chosenActivities,
          votedForReal: votedForReal // what activities have been liked?

      );
      _firestore.collection('groups').doc().set(groupActivity.toJson());
      // every group should have a randomised key so as to avoid duplicates
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
