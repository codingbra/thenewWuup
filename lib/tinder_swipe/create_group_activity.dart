import 'dart:collection';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/controllers/profile_controller.dart';

import 'package:tiktokclone/controllers/swipe_search_controller.dart';

import 'package:tiktokclone/tinder_swipe/swipe_functions/swipe_alert_function.dart';
import 'package:tiktokclone/tinder_swipe/swipe_methods/firestore_methods.dart';
import 'package:tiktokclone/tinder_swipe/swipe_utils/swipe_constants.dart';
import 'package:tiktokclone/views/screens/home_screen.dart';

import 'package:tiktokclone/views/widgets/text_inputField.dart';
import 'package:tiktokclone/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// this is the core class to create group activities where all the information
// is gathered to create a group activity.

class GroupActivity extends StatefulWidget {
  const GroupActivity({Key? key}) : super(key: key);

  @override
  State<GroupActivity> createState() => _GroupActivityState();
}

class _GroupActivityState extends State<GroupActivity> {
  // create all the necessary conrollers for the textfields
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _friendsController = TextEditingController();

  // create instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // RX -> to be double checked
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  //List<String> friendsList = SwipeSearchScreen().friendsChosen;
  final List<String> friendsChosen = [];
  final List<String> friendsChosenUid = [];
  final List<String> votedForReal = [];
  List<String> likedActivities = [];
  List<String> activityCounter = [];
  Map activityLikeMap = {};
  List<String> secondRoundActivities = [];
  List<String> hasVotedInSecondRound = [];
  String secondRoundMainActivity = "";
  String mostFinalActivity = "";


  final SwipeSearchController swipeSearchController =
  Get.put(SwipeSearchController());
  final ProfileController profileController = Get.put((ProfileController()));
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String groupId = "";

  Map<String, dynamic> get user => _user.value;
  bool isInGroup = false;
  final String groupUid = "";
  final String hasVoted = "";
  final List<String> chosenActivities = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _groupNameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _friendsController.dispose();
    super.dispose();
  }

  void postGroup() async {
    setState(() {
      _isLoading = true;
    });

    void addHasPosted() async {

    }

    String uid = firebaseAuth.currentUser!.uid;
    DocumentSnapshot userDoc =
    await firestore.collection('users').doc(uid).get();
    String name = (userDoc.data()! as Map<String, dynamic>)['name'];
    String hasVoted = (userDoc.data()! as Map<String, dynamic>)['uid'];


    DocumentSnapshot likedActivities = await _firestore
        .collection("groups")
        .doc("Liked Activities ${firebaseAuth.currentUser!.uid}")
        .get();

    //List<String> groupPreference = (likedActivities.data()! as Map<String,dynamic>["liked"]);

    // String name = (userDoc.data()! as Map<String, dynamic>)['name'];
    await FirestoreMethods().createGroup(
        _locationController.text,
        uid,
        name,
        _groupNameController.text,
        _timeController.text,
        friendsChosen,
        friendsChosenUid,
        hasVoted,
        chosenActivities,
        votedForReal,
        activityCounter,
        secondRoundActivities,
        hasVotedInSecondRound,
        secondRoundMainActivity,
        mostFinalActivity

    );
  }

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> names = ["Chill", "Drink", "Eat", "Party", "Sport"];
  String postId = const Uuid().v1();

  List<String> howHasUserSwiped = [];
  List<String> userHasVoted = [];
  Map<String, int> counterForActivities = {};

  List<String> likedActivitiesMethod() {
    return likedActivities;
  }
  bool stackFinished = false;

//  void addLikesToMap(String name, int counter){
//    firestore.collection("groups").doc("Liked Activities ${firebaseAuth.currentUser!.uid}").set(
//      {"liked": counterForActivities{name,counter}},
//    );
// }

  @override
  void initState() {
    int counter = 0;
    for (int i = 0; i < names.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Content(text: names[i]),
        likeAction: () {
          actions(context, names[i], "Liked");
          chosenActivities.add(names[i]);
        }, // update database
        nopeAction: () {
          actions(context, names[i], "Rejected");
        },
        superlikeAction: () {
          actions(context, names[i], "SuperLiked");
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  Future<void> getDocument() async {
    DocumentSnapshot likedActivities = await _firestore
        .collection("groups")
        .doc("Liked Activities ${firebaseAuth.currentUser!.uid}")
        .get();
    print(likedActivities.toString());
  }

  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
    FirebaseFirestore.instance.collection('groups');
    print(stackFinished);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Create Your Group"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: "Name your Group: ",
                    icon: Icon(Icons.local_activity),
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                    //autofillHints: ,
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: "Location: ",
                      icon: Icon(Icons.place),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    controller: _timeController,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                        DateFormat('dd.MM.yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _timeController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please invite at least one friend';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        filled: false,
                        hintText: "Add your Friends",
                        hintStyle: TextStyle(fontSize: 18, color: Colors.white)),
                    onFieldSubmitted: (value) =>
                        swipeSearchController.searchUser(value),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                                itemCount:
                                swipeSearchController.searchedUsers.length,
                                itemBuilder: (context, index) {
                                  model.User user =
                                  swipeSearchController.searchedUsers[index];
                                  return InkWell(
                                    onTap: () async {
                                      if (friendsChosen.contains(user.name)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content:
                                            Text("already in group")));
                                      } else if (user.uid ==
                                          firebaseAuth.currentUser!.uid) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                "You cannot add yourself you stupid fuck")));
                                      } else {
                                        friendsChosen.add(user.name);
                                        print(friendsChosen);
                                        friendsChosenUid.add(user.uid);
                                      }
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.profilePhoto,
                                        ),
                                      ),
                                      title: Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 90,
                  ),
                  Text(
                    "Choose your preferences:",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 300,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      names[index],
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              );
                            },
                            onStackFinished: () {
                              stackFinished = true;
                              print(stackFinished);
                              // Future.delayed(Duration(seconds: 3), () {
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => ReadData()));
                              // }
                              // );
                              return ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Congratulations you have made it through :)"),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    child: Center(
                      child: FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.add),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            if(stackFinished == true){
                              votedForReal.add(firebaseAuth.currentUser!.uid);
                              postGroup();
                              //print(friendsList);
                              // FirebaseFirestore.instance.collection('groups').add(friendsList.);//.then((value) => print(
                              //     'DocumentSnapshot added with ID: ${value.id}'));
                              setState(() {});
                              Navigator .of(context).push(MaterialPageRoute(
                                  builder: (context) => ConfirmationScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please swipe all fucking activities are you stupid?"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Some fields are empty, fill them out bitch"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// SHOW THE ACTIVITIES //////////////////////////////////////////////////////////////////////////////////////////
// here the summary of the activity is shown after creating it
class ConfirmationScreen extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    // Referenz festlegen - hier gruppen
    CollectionReference groups =
    FirebaseFirestore.instance.collection('groups');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Activity Created"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context) // here you can go back to the hommescreen
                    .push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home)),
        ],
      ),
      body: StreamBuilder(
        // groups = collection reference as defined above
          stream: groups.orderBy('datePublished', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              // progress indicator if loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              // hole data as querysnapshot in den Dokumenten und mappe - groups
              children: snapshot.data!.docs.map((groups) {
                Timestamp stamp = groups["datePublished"] as Timestamp;
                return Column(
                  children: [
                    // if braucht es denn sonst zeigt es alle kreiierten Aktivitäten an.
                    if (groups["uid"] == FirebaseAuth.instance.currentUser!.uid)
                      Card(
                        elevation: 12,
                        child: ListTile(
                          title: Text(
                            "Activity Created on : ${stamp.toDate()} " +
                                "\nYour group is called: " +
                                groups['groupName'] +
                                "\n the activity will take place on the: " +
                                groups["date"] +
                                "\ntogether with: " +
                                groups['friends'].toString() +
                                "\nwith the following preferences: ${groups["chosenActivities"]}  +  ${groups
                                    .id}  ",
                            style: TextStyle(fontSize: 20, color: Colors.amber),
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

// DEAD CODE ///////////////////////////////////////////
/**
 *
 *
 *
 *     print("Something happened");
    print("Counter" + counterForActivities.toString());
    counterForActivities =
    {names[i].toString, counter} as Map<String, int>;
    firestore
    .collection("Unliked Activities")
    .doc("Unliked Activities")
    .set(
    {"liked": counterForActivities},
    );
 */