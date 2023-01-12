

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/controllers/swipe_search_controller.dart';
import 'package:tiktokclone/tinder_swipe/swipe_functions/swipe_alert_function.dart';
import 'package:tiktokclone/tinder_swipe/swipe_methods/firestore_methods.dart';
import 'package:tiktokclone/tinder_swipe/swipe_utils/swipe_constants.dart';
import 'package:tiktokclone/views/screens/activity_screen.dart';

class SwipeActivityScreen extends StatefulWidget {
  final String activitiyUid;
  final List<dynamic> activities;
  final List<dynamic> baseActivities;
  final List<dynamic> hasVoted;
  final String nameOfAcivitiy;

  SwipeActivityScreen(
      {super.key,
      required this.activitiyUid,
      required this.activities,
      required this.baseActivities,
      required this.hasVoted,
      required this.nameOfAcivitiy});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  State<SwipeActivityScreen> createState() => _SwipeActivityScreenState();
}

class _SwipeActivityScreenState extends State<SwipeActivityScreen> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  FirestoreMethods firestoreMethods = FirestoreMethods();

  MatchEngine? _matchEngine;

  late List<dynamic> hasVoted = widget.hasVoted;


  late List<dynamic> chosenActivities = widget.baseActivities;
  Map<String, int> counterForActivities = {};
  final List<String> friendsChosen = [];
  final List<String> friendsChosenUid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  late List<dynamic> names = widget.activities;
 // final SwipeSearchController swipeSearchController =
  //Get.put(SwipeSearchController());

  List <String> imagesChosen = [];

 late int index = 0;
  List<dynamic> indexList = [];

  @override
  void initState()  {


    for(var item in widget.activities){
      for(var imageItem in images){
        if(imageItem.toString().contains(item)){
          imagesChosen.add(imageItem);
          print("These are the chosen images $imagesChosen");

        }
      }
    }

     int counter = 0;
    for (int i = 0; i < names.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Content(text: names[i]),
        likeAction: () {
          actions(context, names[i], "Liked");
          chosenActivities.add(names[i]);
          print("as of now these are the activities$chosenActivities");
        }, // update database
        nopeAction: () {
          print("Something to print");
          actions(context, names[i], "Rejected");
          counterForActivities =
          {names[i].toString, counter} as Map<String, int>;
          firestore
              .collection("Unliked Activities")
              .doc(widget.activitiyUid)
              .set(
            {"friends": counterForActivities},
          );
          print(counterForActivities.toString());

        },
        superlikeAction: () {
          actions(context, names[i], "SuperLiked");
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    
    // for(int i = 0; i <images.length; i++){
    //   if(chosenActivities.contains(images[i])){
    //     counter = i;
    //     print(counter);
    //   }
    //
    // }

    print("These were the chosen activities: ${widget.activities}");

    for(var item in widget.activities){
      if(images.contains(item)){
        print("is contained");
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameOfAcivitiy),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 600,
                        child: SwipeCards(
                          matchEngine: _matchEngine!,



                          itemBuilder: (BuildContext context, int index) {
                            // int index = 0;
                            //
                            // // for(var item in widget.activities){
                            // //   for(var imageItem in images){
                            // //     if(imageItem.toString().contains(item)){
                            // //
                            // //     }
                            // //   }
                            // // }
                            //
                            // for(int i = 0; i<images.length; i++){
                            //   for(int j = 0; j<widget.activities.length; j++){
                            //     if(images[i].toString().contains(widget.activities[j])){
                            //       index = i;
                            //     }
                            //   }
                            //
                            //   print("this is the indexlist : $indexList");
                            // }
                            //
                            // for(var item in indexList){
                            //   index = item;
                            // }
                            // print("this is the index: $index");







                            return Container(
                             alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                 image: DecorationImage(
                                   image: AssetImage(
                                       imagesChosen[index]),
                                   fit: BoxFit.cover,
                                ),
                                color: Colors.black,
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
                            hasVoted.add(firebaseAuth.currentUser!.uid);
                            print("these are the people that have voted $hasVoted");
                            print("names on stack finished: $chosenActivities");
                            firestoreMethods.addActivities(widget.activitiyUid, chosenActivities, hasVoted);
                            print("These are the chosen images $imagesChosen");
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
              ],
            ),
          ),
        ),
      ),

    );
  }
}


// FirebaseFirestore.instance
//     .collection('groups')
//     .doc(widget.activitiyUid)
//     .get()
//     .then((DocumentSnapshot documentSnapshot) {
//   if (documentSnapshot.exists) {
//     List<dynamic> nested = documentSnapshot.get(FieldPath(["chosenActivities"]));
//     names = nested;
//     print(nested);
//     print(names);
//     print('Document data: ${documentSnapshot.data()}');
//   } else {
//     print('Document does not exist on the database');
//   }
// });

//names = firestore.collection("groups").doc(widget.activitiyUid).collection("chosenActivities")