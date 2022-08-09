import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/tinder_swipe/create_group_activity.dart';
import 'package:tiktokclone/tinder_swipe/swipe_functions/swipe_alert_function.dart';
import 'package:tiktokclone/tinder_swipe/swipe_utils/swipe_constants.dart';
import 'package:tiktokclone/tinder_swipe/swipe_widgets/swipe_app_bar.dart';
import 'package:tiktokclone/views/screens/home_screen.dart';
import 'package:uuid/uuid.dart';

class HomeSwipe extends StatefulWidget {
  const HomeSwipe({Key? key}) : super(key: key);

  @override
  State<HomeSwipe> createState() => _HomeSwipeState();
}

class _HomeSwipeState extends State<HomeSwipe> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> names = ["Chill", "Drink", "Eat", "Party", "Sport"];
  String postId = const Uuid().v1();
  List<String> likedActivities = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  @override
  void initState() {
    for (int i = 0; i < names.length; i++) { // go through above declared list of activities
      _swipeItems.add(SwipeItem(
        content: Content(text: names[i]),
        likeAction: () {
          actions(context, names[i], "Liked");
          likedActivities.add(names[i]);
          firestore.collection("groups").doc("Liked Activities ${firebaseAuth.currentUser!.uid}").set(
            {"liked": likedActivities}, // loop through the activities
          );
        }, // update database
        nopeAction: () {
          actions(context, names[i], "Rejected");
        },
        superlikeAction: () { // does not work somehow
          actions(context, names[i], "SuperLiked");
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SwipeTopBar(),
            const SizedBox(
              // pading from top
              height: 70,
            ),

            Expanded(
              child: Container(
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
                    // Creates a future that runs its computation after a delay // like sleep for callable
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GroupActivity()));
                    });
                    return
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ),
    );
  }
}

class Content {
  final String text;

  Content({required this.text});
}
