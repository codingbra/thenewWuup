

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupActivityPackage{
  final String username;
  final String uid;
  final String groupName;
  final String date;
  final String location;
  final List<String> friends;
  final DateTime datePublished;
  final List<String> friendsChosenUid;
  final String hasVoted;
  final List<String> chosenActivities;
  final List<String> votedForReal;



  // String comment;
  // final datePublished;
  // List likes;
  // String profilePhoto;


  GroupActivityPackage({
    required this.username,
    required this.uid,
    required this.groupName,
    required this.date,
    required this.location,
    required this.friends,
    required this.datePublished,
    required this.friendsChosenUid,
    required this.hasVoted,
    required this.chosenActivities,
    required this.votedForReal,



  });

  Map<String, dynamic> toJson() => {
    'username' : username,
    'uid' : uid,
    'date' : date,
    'groupName' : groupName,
    'location' : location,
    'friends' : friends,
    "datePublished" : datePublished,
    "friendsChosenUid" : friendsChosenUid,
    "hasVoted" : hasVoted,
    "chosenActivities" : chosenActivities,
    "hasVotedForReal" :votedForReal
  };

  static GroupActivityPackage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return GroupActivityPackage(
        username: snapshot['username'],
        uid: snapshot['comment'],
        groupName: snapshot['groupName'],
        location: snapshot['location'],
        friends: snapshot['friends'],
        date: snapshot['date'],
        datePublished: snapshot["datePublished"],
        chosenActivities: snapshot["chosenActivities"],
        hasVoted: snapshot["hasVoted"],
        friendsChosenUid: snapshot["friendsChosenUid"],
        votedForReal: snapshot["hasVotedForReal"]
    );
  }
}