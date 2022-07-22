

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/controllers/profile_controller.dart';
import 'package:tiktokclone/tinder_swipe/swipe_utils.dart';
import 'package:tiktokclone/views/screens/SwipeActivityScreen.dart';
import 'package:tiktokclone/views/screens/home_screen.dart';
import 'package:tiktokclone/models/user.dart' as model;
import 'package:tiktokclone/views/screens/profile_screen.dart';

class ActivityScreen extends StatefulWidget {
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DocumentSnapshot documentSnapshotPic;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //final User user = User as User;
  ProfileController profileController = ProfileController();

  Future<String> getThemLikes() async {
    DocumentSnapshot likedActivities = await FirebaseFirestore.instance
        .collection("groups")
        .doc("Liked Activities ${firebaseAuth.currentUser!.uid}")
        .get();
    return likedActivities.toString();
  }

  Future<void> checkWhetherUidExistsInSnap() async {
    // final uid = firebaseAuth.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('groups');
    var doc = await users.doc("uid").get();
    if (doc.id.contains(uid)) {
      print("It happened baby");
    } else {
      print("Data not contained");
    }
  }

  dynamic data;

  Future<dynamic> getData() async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  final String documentId = "";

  GetUserName(String documentId) {
    return this.documentId;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');
    DocumentReference document = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home)),
        ],
      ),
      body: StreamBuilder(
          //stream: FirebaseFirestore.instance.collection('groups').snapshots(),
          stream: groups.orderBy('datePublished', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((groups) {
                Timestamp stamp = groups["datePublished"] as Timestamp;
                return Column(
                  children: [
                    Card(
                      elevation: 12,
                      child: ListTile(
                        leading:
                        (groups["uid"] ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("You have created"),
                                    Container(
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: users
                                            .doc(firebaseAuth.currentUser!.uid)
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return Text("Something went wrong");
                                          }

                                          if (snapshot.hasData &&
                                              !snapshot.data!.exists) {
                                            return Text(
                                                "Document does not exist");
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            return CircleAvatar(
                                                foregroundImage: NetworkImage(
                                              data["profilePhoto"].toString(),
                                              //Image.network(data["profilePhoto"])
                                            ) //;
                                                );
                                            // return Image.network(data["profilePhoto"]);
                                            //return Text("Full Name: ${data['profilePhoto']} ${data['name']}");
                                          }
                                          return Text("loading");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Text("You have been invited by:"),
                                  Container(
                                    child: FutureBuilder<DocumentSnapshot>(
                                      future: users.doc(groups["uid"]).get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return Text(
                                              "Document does not exist");
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileScreen(
                                                    uid: data["uid"],
                                                  ),
                                                )),
                                                child: CircleAvatar(
                                                    foregroundImage:
                                                        NetworkImage(
                                                  data["profilePhoto"]
                                                      .toString(),
                                                  //Image.network(data["profilePhoto"])
                                                ) //;
                                                    ),
                                              ),
                                            ],
                                          );
                                          // return Image.network(data["profilePhoto"]);
                                          //return Text("Full Name: ${data['profilePhoto']} ${data['name']}");
                                        }
                                        return Text("loading");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        title: Column(
                          children: [
                            Text(
                              "${groups["username"]} : ${stamp.toDate()} :" +
                                  "\nYour Activity is called: " +
                                  groups['groupName'] +
                                  "\n the activity will take place on the: " +
                                  groups["date"] +
                                  "\ntogether with: " +
                                  groups['friends'].toString() +
                                  "\nwith the following preferences: ${groups["chosenActivities"]} ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.amber),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: (){
                                  firestore.collection('groups').doc().update(data);

                                },
                                child: Text("add chill"),
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  if(groups["hasVoted"]==firebaseAuth.currentUser?.uid){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(
                                            "You have already voted on this activity")));
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SwipeActivityScreen(), // here the pre selected sample should be shown.
                                    ));
                                  }
                                },
                                child: Text("Go to Activity"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );

            return Text("Something went wrong");
          }),
    );
  }
}

class Content {
  final String text;

  Content({required this.text});
}
