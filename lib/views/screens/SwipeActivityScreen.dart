import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/controllers/swipe_search_controller.dart';
import 'package:tiktokclone/tinder_swipe/swipe_functions/swipe_alert_function.dart';
import 'package:tiktokclone/tinder_swipe/swipe_utils/swipe_constants.dart';

class SwipeActivityScreen extends StatefulWidget {
  const SwipeActivityScreen({Key? key}) : super(key: key);

  @override
  State<SwipeActivityScreen> createState() => _SwipeActivityScreenState();
}



class _SwipeActivityScreenState extends State<SwipeActivityScreen> {

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> names = ["Chill", "Drink", "Eat", "Party", "Sport"];
  final List<String> chosenActivities = [];
  Map<String, int> counterForActivities = {};
  final List<String> friendsChosen = [];
  final List<String> friendsChosenUid = [];

  final SwipeSearchController swipeSearchController =
  Get.put(SwipeSearchController());

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
          print("Something to print");
          actions(context, names[i], "Rejected");
          counterForActivities =
          {names[i].toString, counter} as Map<String, int>;
          firestore
              .collection("Unliked Activities")
              .doc("Unliked Activities")
              .set(
            {"liked": counterForActivities},
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe your invitation"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                // Text(
                //   "Choose your preferences:",
                //   style: TextStyle(fontSize: 20),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 600,
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
              ],
            ),
          ),
        ),
      ),

    );
  }
}

class Content {
  final String text;

  Content({required this.text});
}

