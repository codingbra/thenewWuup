

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

import '2ndRoundScreen.dart';

class ActivityScreen extends StatefulWidget {



  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DocumentSnapshot documentSnapshotPic;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final newActivity = <String, dynamic>{"chosenActivities" : ["asdfgads", "sdafsdgsadfgdasdf"]};
  CollectionReference groups =
  FirebaseFirestore.instance.collection('groups');
  //final User user = User as User;
  ProfileController profileController = ProfileController();

  List<dynamic> usersThatHaveVoted = [];
  List<dynamic> theseAreTheUsersThatVoted = [];
  List<dynamic> theseAreTheFriendsInvited = [];
  late final String activityForSecond;



  Future<String> checkFor2ndRoundActivity() async {


    await FirebaseFirestore.instance
        .collection('groups')
        .doc(documentId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String secondRoundActivity =
        documentSnapshot.get(FieldPath(["secondRoundMainActivity"]));
        // for(var elements in nested) {
        //   chosenActivities.add(elements);
        // }
        activityForSecond = secondRoundActivity;
        print("these are the user that have voted ${activityForSecond}");

      } else {
        print('Document does not exist on the database');
      }
    });
    return activityForSecond;
  }



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


  Future<bool> CheckWhetherAllVoted()async{

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groups.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        List<dynamic> nested = documentSnapshot.get(FieldPath(["hasVotedForReal"]));
        // for(var elements in nested) {
        //   chosenActivities.add(elements);
        // }
        theseAreTheUsersThatVoted = nested;
        print("these are the user that have voted ${usersThatHaveVoted}");
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groups.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        List<dynamic> nested = documentSnapshot.get(FieldPath(["friendsChosenUid"]));
        // for(var elements in nested) {
        //   chosenActivities.add(elements);
        // }
        theseAreTheFriendsInvited = nested;
        print("these are the user that have voted ${usersThatHaveVoted}");
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    if(theseAreTheFriendsInvited.length == theseAreTheUsersThatVoted.length) {
      return true;
    } else {
      return false;
    }

  }


  final String documentId = "";

  GetUserName(String documentId) {
    return this.documentId;
  }

  Map<String, int> count = {};


  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    CheckWhetherAllVoted();
  print(CheckWhetherAllVoted());


    DocumentReference chosenActivties = FirebaseFirestore.instance
        .collection("groups")
        .doc(firebaseAuth.currentUser!.uid);


    DocumentReference document = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('users');


    FirebaseFirestore.instance
        .collection('groups')
        .doc(groups.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        List<dynamic> nested = documentSnapshot.get(FieldPath(["hasVotedForReal"]));
        // for(var elements in nested) {
        //   chosenActivities.add(elements);
        // }
        usersThatHaveVoted = nested;

        print("these are the user that have voted ${usersThatHaveVoted}");
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    Map<String, int> count = {};
    List<dynamic> counterOfActivities = [];





    // List<dynamic> listNames = [];
    // List<dynamic> friendsUids = [];
    //
    // for(var items in groups["hasVotedForReal"]) {
    //   listNames.add(items);}
    // for(var items in groups["friendsChosenUid"]) {
    //   friendsUids.add(items);}
    // if(listNames.length!=friendsUids.length){
    //   print("all have voted");
    // }
    // print("these are the list names : ${listNames}");
    // print("these are the friendsUids names : ${friendsUids}");
    //
    // if (groups["hasVoted"]==firebaseAuth.currentUser!.uid && listNames.length==friendsUids.length+1 ) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(
    //
    //       content: Text(
    //           "You have already voted on this activity")));
    //
    //
    //



    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home)),
        ],
      ),
      // in the stream builder we read data from the database
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

                List<dynamic> listNames = [];
                List<dynamic> friendsUids = [];


                for(var items in groups["hasVotedForReal"]) {
                  listNames.add(items);}
                for(var items in groups["friendsChosenUid"]) {
                  friendsUids.add(items);}


                return Column(
                  children: [








//////////////////////////////////////// CASE ALL HAVE DECIDED ON ACTIVITY////////////////////////////////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
                   for (var item in groups["friendsChosenUid"])
                   if( listNames.length == friendsUids.length+1)
                   // case I have been invited:
                     if(item == FirebaseAuth.instance.currentUser!.uid)
                     Card(
                       color: Colors.blueGrey,

                       elevation: 12,
                       child: ListTile(
                         leading:
                         SingleChildScrollView(
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             mainAxisSize: MainAxisSize.max,
                             children: [
                               Text("Creator: ${groups["username"]}"),
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
                                                 )
                                                 ),
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
                         ),
                         title: Column(
                           children: [
                             Text(
                               "${groups["username"]} : ${stamp.toDate()} :" +
                                   "\n\nYour Activity is called: " +
                                   groups['groupName'] +
                                   "\n\n the activity will take place on the: " +
                                   groups["date"] +
                                   "\n\ntogether with: " +
                                   groups['friends'].toString() +
                                   "\n\nwith the following preferences: ${groups["chosenActivities"]} "
                                   + "\n\n The Chosen Acivities were: : ${groups["activityCounter"]}"
                                   + "\n\nThe Voting on this activity is closed. Please proceed to the second round via the button below",
                               style: TextStyle(
                                   fontSize: 20, color: Colors.amber),
                             ),
                             Container(
                               child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(primary: Colors.green),
                                 onPressed: () {
                                   // if (groups["hasVoted"]==firebaseAuth.currentUser!.uid) {
                                   //   ScaffoldMessenger.of(context)
                                   //       .showSnackBar(SnackBar(
                                   //       content: Text(
                                        //           "You have already voted on this activity")));
                                        //
                                        // } else {
                                        print(groups.id);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              SecondRoundScreen(
                                            activitiyUid: groups.id,
                                            activities:
                                                groups["chosenActivities"],
                                            baseActivities:
                                                groups["activityCounter"],
                                            hasVoted: groups["hasVotedForReal"],
                                            nameOfAcivitiy: groups["groupName"],
                                            secondRoundActivities:
                                                groups["secondRoundActivities"],
                                                secondRoundVotes: groups["hasVotedInSecondRound"],
                                                  secondRoundFinalActivity: groups["secondRoundMainActivity"]
                                          ),
                                          // here the pre selected sample should be shown.
                                        ));
                                      },
                                      child: Text("Go to 2nd Round"),
                                    ),
                                  )
                                ],
                         ),
                       ),
                     ),
                    // case I have created:
                    if(listNames.length == friendsUids.length+1)
                      if(groups["uid"] ==
                          FirebaseAuth.instance.currentUser!.uid)
                      Card(
                        color: Colors.blueGrey,
                        elevation: 12,
                        child: ListTile(
                          leading:
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Creator: ${groups["username"]}"),
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
                          ),
                          title: Column(

                            children: [
                              Text(
                                "${groups["username"]} : ${stamp.toDate()} :" +
                                    "\n\nYour Activity is called: " +
                                    groups['groupName'] +
                                    "\n\n the activity will take place on the: " +
                                    groups["date"] +
                                    "\n\ntogether with: " +
                                    groups['friends'].toString() +
                                    "\n\nwith the following preferences: ${groups["chosenActivities"]} "
                                    + "id : ${groups.id}"
                                    + "\n\nThe Voting on this activity is closed. Please proceed to the second round via the button below",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.amber),
                              ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.green),
                                  onPressed: () {
                                    // if (groups["hasVoted"]==firebaseAuth.currentUser!.uid) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //       content: Text(
                                    //           "You have already voted on this activity")));
                                    //
                                      // } else {
                                      print(groups.id);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => SecondRoundScreen(
                                          activitiyUid: groups.id,
                                          activities:
                                              groups["chosenActivities"],
                                          baseActivities:
                                              groups["activityCounter"],
                                          hasVoted: groups["hasVotedForReal"],
                                          nameOfAcivitiy: groups["groupName"],
                                          secondRoundActivities:
                                          groups["secondRoundActivities"],
                                          secondRoundVotes: ["hasVotedInSecondRound"],
                                            secondRoundFinalActivity: groups["secondRoundMainActivity"]
                                        ),
                                        // here the pre selected sample should be shown.
                                      ));
                                    },
                                    child: Text("Go to 2nd Round"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),











//////////////////////////////////////// CASE YOUR OWN ACTIVITY ///////////////////////// ///////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
                   if (groups["uid"] ==
                        FirebaseAuth.instance.currentUser!.uid && listNames.length != friendsUids.length+1)
                    Card(
                      elevation: 12,
                      child: ListTile(
                        leading:
                             SingleChildScrollView(
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
                              ),
                        title: Column(

                          children: [
                            Text(
                              "${groups["username"]} : ${stamp.toDate()} :" +
                                  "\n\nYour Activity is called: " +
                                  groups['groupName'] +
                                  "\n\n the activity will take place on the: " +
                                  groups["date"] +
                                  "\n\ntogether with: " +
                                  groups['friends'].toString() +
                                  groups['friendsChosenUid'].toString() +
                                  "\n\nwith the following preferences: ${groups["chosenActivities"]} "
                                      + "id : ${groups.id}"

                              + "\n\nhasVoted: ${groups["hasVotedForReal"]}"
                          + "\n\n has everybody voted?: ${CheckWhetherAllVoted()}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.amber),
                              ),
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                      if (groups["hasVoted"]==firebaseAuth.currentUser!.uid) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(

                                                content: Text(
                                                    "You have already voted on this activity")));

                                    } else {
                                        print(groups.id);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              SwipeActivityScreen(
                                                  activitiyUid: groups.id, activities: groups["chosenActivities"],baseActivities: groups["activityCounter"], hasVoted: groups["hasVotedForReal"], nameOfAcivitiy: groups["groupName"],
                                          ),
                                          // here the pre selected sample should be shown.
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










//////////////////////////////////////// CASE YOU HAVE BEEN INVITED ///////////////////////// ///////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
                    for (var item in groups["friendsChosenUid"])
                      if (item == FirebaseAuth.instance.currentUser!.uid && listNames.length != friendsUids.length+1)
                        Card(
                          elevation: 12,
                      child: ListTile(
                        leading:
                             SingleChildScrollView(
                              child: Column(
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
                            ),
                        title: Column(
                          children: [
                            Text(
                              "${groups["username"]} : ${stamp.toDate()} :" +
                                  "\n\nYour Activity is called: " +
                                  groups['groupName'] +
                                  "\n\n the activity will take place on the: " +
                                  groups["date"] +
                                  "\n\ntogether with: " +
                                  groups['friends'].toString() +
                                 "\n\nThese are the chosen Activities so far:  ${groups["activityCounter"]}"
                                  + "\n\nhasVoted: ${groups["hasVotedForReal"]}"
                                  + "\n\n has everybody voted?: ${CheckWhetherAllVoted()}",
                              style:
                              TextStyle(fontSize: 20, color: Colors.amber),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: ()  {
                                  List<dynamic> listNames = [];
                                  List<dynamic> friendsUids = [];
                                  List<dynamic> activityCounter = groups["activityCounter"];
                                  print("this is the current user ${firebaseAuth.currentUser!.uid}");
                                  print("These are the users that have voted ${groups["hasVotedForReal"]}");
                                  print("These are the chosen Activities ${groups["activityCounter"]}");
                                  for(var items in groups["hasVotedForReal"]) {
                                    listNames.add(items);}
                                  for(var items in groups["friendsChosenUid"]) {
                                    friendsUids.add(items);}
                                    if(listNames.length!=friendsUids.length){
                                      print("all have voted");
                                    }
                                    if(listNames.contains(firebaseAuth.currentUser!.uid)){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(
                                            "You have already voted on ${groups["groupName"]}")));
                                    Navigator.of(context).pop(MaterialPageRoute(
                                        builder: (context) => ProfileScreen(uid: firebaseAuth.currentUser!.uid,)));

                                  }  else {
                                    print(groups.id);
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SwipeActivityScreen(activitiyUid: groups.id, activities: groups["chosenActivities"],baseActivities: groups["activityCounter"], hasVoted: groups["hasVotedForReal"], nameOfAcivitiy: groups["groupName"])
                                      // here the pre selected sample should be shown.

                                    ));
                                  }

                                },
                                child: Text("Go to Activity"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                );
              }).toList(),
            );

            return Text("Something went wrong");
          }
          ),
    );
  }

  FirebaseFirestore get firestore => _firestore;
}

class Content {
  final String text;

  Content({required this.text});
}

// Container(
// child: ElevatedButton(
// onPressed: (){
// for(int i = 0; i< newActivity.length; i++){
// firestore.collection('groups').doc(groups.id).update(newActivity);
// }
//
// },
// child: Text("add chill"),
// ),
// ),