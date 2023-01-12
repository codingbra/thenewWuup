import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tiktokclone/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../tinder_swipe/create_group_activity.dart';
import '../../tinder_swipe/swipe_functions/swipe_alert_function.dart';
import '../../tinder_swipe/swipe_methods/firestore_methods.dart';
import '../../tinder_swipe/swipe_utils/swipe_constants.dart';
import 'finalActivityScreen.dart';
import 'home_screen.dart';

class SecondRoundScreen extends StatefulWidget {
  final String activitiyUid;
  final List<dynamic> activities;
  final List<dynamic> baseActivities;
  final List<dynamic> hasVoted;
  final String nameOfAcivitiy;
  final List<dynamic> secondRoundActivities;
  final List<dynamic> hasVotedInSecondRound;
  final String secondRoundFinalActivity;

  const SecondRoundScreen(
      {super.key,
      required this.activitiyUid,
      required this.activities,
      required this.baseActivities,
      required this.hasVoted,
      required this.nameOfAcivitiy,
      required this.secondRoundActivities,
      required this.hasVotedInSecondRound,
        required this.secondRoundFinalActivity
      });

  @override
  State<SecondRoundScreen> createState() => _SecondRoundScreenState();
}

class _SecondRoundScreenState extends State<SecondRoundScreen> {
  FirestoreMethods firestoreMethods = FirestoreMethods();
  int counter = 0;

  late List<dynamic> listOfTheFirstRoundActivities = widget.baseActivities;
  var map = {};
  final String _url = 'https://flutter-examples.com';
  List<Map<dynamic, dynamic>> data = [];
  var maxOccurrence = 0;
  var i = 0;
  var popularActivities = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late List<dynamic> secondRoundVotes = widget.hasVotedInSecondRound;
  late List<dynamic> activitiesOfSecondRound = widget.secondRoundActivities;
  late String finalActivity = widget.secondRoundFinalActivity;

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  //
  // String getTheRandomOnes(){
  //   finalActivity = getRandomElement(popularActivities).toString();
  //   return finalActivity;
  // }

  List<String> eat = ["Japanese", "Swiss", "Mexican", "American", "Chinese"];
  List<String> party = ["Bar", "Club", "Lounge", "Rave", "Festival"];
  List<String> chill = ["Massage", "Shisha", "Stay at home", "Bathing", "Yoga"];
  List<String> sport = ["Hiking", "Swimming", "Parachute", "Mini Golf", "Golf"];
  List<String> travel = [
    "Cruising",
    "Town Holidays",
    "Safari",
    "Beach Holidays",
    "Sport Holidays"
  ];

  final List<String> chosenActivities = [];

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;


  late bool doesExist = true;


  Future<String> checkFor2ndRoundActivity() async {


    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.activitiyUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String secondRoundActivity =
            documentSnapshot.get(FieldPath(["secondRoundMainActivity"]));
        // for(var elements in nested) {
        //   chosenActivities.add(elements);
        // }
        finalActivity = secondRoundActivity;
        print("these are the user that have voted ${finalActivity}");
        doesExist = true;
      } else {
        print('Document does not exist on the database');
        doesExist = false;
      }
    });
    return finalActivity;
  }

  @override
  void initState()  {

    print("from the last screen : ${widget.secondRoundFinalActivity}");
    print("this is the new activity from last time $finalActivity");
    print("this is the current user: ${firebaseAuth.currentUser!.uid}");

    // CollectionReference secondRoundActivityConfirmation = firestore.collection("groups");
    // var doc = secondRoundActivityConfirmation.doc(widget.activitiyUid).collection("secondRoundMainActivity").get();
    // print(doc);
    //

   // if(!doesExist) {
     //finalActivity = checkFor2ndRoundActivity as String;
     // print("this is the final activity from FB{$finalActivity}");
    if(finalActivity.isEmpty) {
      listOfTheFirstRoundActivities.forEach((element) {
        if (!map.containsKey(element)) {
          map[element] = 1;
        } else {
          map[element] += 1;
        }
      });
      print(map);

      while (i < listOfTheFirstRoundActivities.length) {
        var number = listOfTheFirstRoundActivities[i];
        var occurrence = 1;
        for (int j = 0; j < listOfTheFirstRoundActivities.length; j++) {
          if (j == i) {
            continue;
          } else if (number == listOfTheFirstRoundActivities[j]) {
            occurrence++;
          }
        }
        listOfTheFirstRoundActivities.removeWhere((it) => it == number);
        data.add({number: occurrence});
        if (maxOccurrence < occurrence) {
          maxOccurrence = occurrence;
        }
      }

      data.forEach((map) {
        if (map[map.keys.toList()[0]] == maxOccurrence) {
          popularActivities.add(map.keys.toList()[0]);
        }
      });

      print("these are the most popular activities : ${popularActivities}");
      //  print("randomactivitiy: ${getRandomElement(popularActivities)}");

      finalActivity = getRandomElement(popularActivities).toString();
      print("this is the final activity in initstate: ${finalActivity}");
    }

    if (finalActivity.toString().contains("Party")) {
      for (int i = 0; i < party.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: party[i]),
          likeAction: () {
            actions(context, party[i], "Liked");
            activitiesOfSecondRound.add(party[i]);
            print("as of now these are the activities$activitiesOfSecondRound");
          }, // update database
          nopeAction: () {
            actions(context, party[i], "Rejected");
          },
          superlikeAction: () {
            actions(context, party[i], "SuperLiked");
          },
        ));
      }
    }
    if (finalActivity.toString().contains("Eat")) {
      for (int i = 0; i < eat.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: eat[i]),
          likeAction: () {
            actions(context, eat[i], "Liked");
            activitiesOfSecondRound.add(eat[i]);
            print("as of now these are the activities$activitiesOfSecondRound");
          }, // update database
          nopeAction: () {
            actions(context, eat[i], "Rejected");
          },
          superlikeAction: () {
            actions(context, eat[i], "SuperLiked");
          },
        ));
      }
    }

    if (finalActivity.toString().contains("Drink")) {
      for (int i = 0; i < travel.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: travel[i]),
          likeAction: () {
            actions(context, travel[i], "Liked");
            activitiesOfSecondRound.add(travel[i]);
            print("as of now these are the activities$activitiesOfSecondRound");
          }, // update database
          nopeAction: () {
            actions(context, travel[i], "Rejected");
          },
          superlikeAction: () {
            actions(context, travel[i], "SuperLiked");
          },
        ));
      }
    }
    if (finalActivity.toString().contains("Sport")) {
      for (int i = 0; i < sport.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: sport[i]),
          likeAction: () {
            actions(context, sport[i], "Liked");
            activitiesOfSecondRound.add(sport[i]);
            print("as of now these are the activities$activitiesOfSecondRound");
          }, // update database
          nopeAction: () {
            actions(context, sport[i], "Rejected");
          },
          superlikeAction: () {
            actions(context, sport[i], "SuperLiked");
          },
        ));
      }
    }
    if (finalActivity.toString().contains("Chill")) {
      for (int i = 0; i < chill.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: chill[i]),
          likeAction: () {
            actions(context, chill[i], "Liked");
            activitiesOfSecondRound.add(chill[i]);
            print("as of now these are the activities$activitiesOfSecondRound");
          }, // update database
          nopeAction: () {
            actions(context, chill[i], "Rejected");
          },
          superlikeAction: () {
            actions(context, chill[i], "SuperLiked");
          },
        ));
      }
    }


    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2nd ROUND: ${widget.nameOfAcivitiy}"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home)),
        ],
      ),
      body: SizedBox(
        child: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              // String finalActivity = getRandomElement(popularActivities).toString();
              // print(finalActivity);

              return Card(
                child: Column(
                  children: [


                    // Row(
                    //   children: [
                    //     Text("The chosen Activities${map}"),
                    //   ],
                    // ),
                    // SizedBox(height: 40),
                    // Row(
                    //   children: [
                    //     Text(
                    //         "Therefore, the chosen Activities is: $finalActivity"),
                    //   ],
                    // ),
                    // SizedBox(height: 40),
                    // Row(
                    //   children: [
                    //     Text("The Subcategories of this activites are: "),
                    //   ],
                    // ),
                    // SizedBox(
                    //   child: Column(
                    //     children: [
                    //       if (finalActivity == "Chill") Text(chill.toString()),
                    //       if (finalActivity == "Eat") Text(eat.toString()),
                    //       if (finalActivity == "Sport") Text(sport.toString()),
                    //       if (finalActivity == "Drink") Text(travel.toString()),
                    //       if (finalActivity == "Party") Text(party.toString())
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50,
                    // ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     final url = Uri.parse(
                    //       'https://www.youtube.com/watch?v=xvFZjo5PgG0&ab_channel=Duran',
                    //     );
                    //     if (await canLaunchUrl(url)) {
                    //       launchUrl(url);
                    //     } else {
                    //       // ignore: avoid_print
                    //       print("Can't launch $url");
                    //     }
                    //   },
                    //   child: const Text('More Information just for you!!!'),
                    // ),

                    // ACTIVITY == EAT

                    if (finalActivity == "Eat")
                      Flexible(
                        child: SizedBox(
                          height: 700,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(eatImages[index]),
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
                                      eat[index],
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
                              secondRoundVotes
                                  .add(firebaseAuth.currentUser!.uid);
                              print(
                                  "these are the people that have voted $secondRoundVotes");
                              print(
                                  "names on stack finished: $activitiesOfSecondRound");
                              firestoreMethods.addSecondRoundVoting(
                                  widget.activitiyUid,
                                  activitiesOfSecondRound,
                                  secondRoundVotes,
                                  finalActivity);
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

                    // ACTIVITY == CHILL
                    if (finalActivity == "Chill")
                      Flexible(
                        child: SizedBox(
                          height: 700,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(chillImages[index]),
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
                                      chill[index],
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
                              secondRoundVotes
                                  .add(firebaseAuth.currentUser!.uid);
                              print("these are the mfs that have voted in snd round $secondRoundVotes");
                              firestoreMethods.addSecondRoundVoting(
                                  widget.activitiyUid,
                                  activitiesOfSecondRound,
                                  secondRoundVotes,
                                  finalActivity);
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

                    // ACTIVITY == PARTY

                    if (finalActivity == "Travel")
                      Flexible(
                        child: SizedBox(
                          height: 700,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(travelImages[index]),
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
                                      travel[index],
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
                              secondRoundVotes
                                  .add(firebaseAuth.currentUser!.uid);
                              firestoreMethods.addSecondRoundVoting(
                                  widget.activitiyUid,
                                  activitiesOfSecondRound,
                                  secondRoundVotes,
                                  finalActivity);
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

                    if (finalActivity == "Party")
                      Flexible(
                        child: SizedBox(
                          height: 700,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(partyImages[index]),
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
                                      party[index],
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
                              secondRoundVotes
                                  .add(firebaseAuth.currentUser!.uid);
                              firestoreMethods.addSecondRoundVoting(
                                  widget.activitiyUid,
                                  activitiesOfSecondRound,
                                  secondRoundVotes,
                                  finalActivity);
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

                    // FINAL ACTIVITY = SPORT

                    if (finalActivity == "Sport")
                      Flexible(
                        child: SizedBox(
                          height: 700,
                          child: SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(sportImages[index]),
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
                                      sport[index],
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
                              print("this is the final activity on stack finished $finalActivity");
                              secondRoundVotes
                                  .add(firebaseAuth.currentUser!.uid);
                              print("these are the mfs that have voted in snd round $secondRoundVotes");
                              print("this is the current user: ${firebaseAuth.currentUser!.uid}");
                              firestoreMethods.addSecondRoundVoting(
                                  widget.activitiyUid,
                                  activitiesOfSecondRound,
                                  secondRoundVotes,
                                  finalActivity);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const FinalActivityScreen(),
                              ));
                              return ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
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
              );
            }),
      ),
    );
  }
}
