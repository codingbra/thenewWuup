import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../tinder_swipe/swipe_methods/firestore_methods.dart';


// 1st step > final random selection of 2nd round activities

class FinalScreen extends StatefulWidget {

  final String activitiyUid;
  final List<dynamic> activities;
  final List<dynamic> baseActivities;
  final List<dynamic> hasVoted;
  final String nameOfAcivitiy;
  final List<dynamic> secondRoundActivities;
  final List<dynamic> hasVotedInSecondRound;
  final String secondRoundFinalActivity;
  final String location;
  final String time;
  final List<dynamic> sndRoundActivities;
  final String mostFinalActivity;

  const FinalScreen({
    Key? key,
    required String this.activitiyUid,
    required this.activities,
    required this.baseActivities,
    required this.hasVoted,
    required this.nameOfAcivitiy,
    required this.secondRoundActivities,
    required this.hasVotedInSecondRound,
    required this.secondRoundFinalActivity,
    required this.location,
    required this.time, required this.sndRoundActivities, required this.mostFinalActivity,
  }) : super(key: key);

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {

  FirestoreMethods firestoreMethods = FirestoreMethods();

  late List<dynamic> listOfSecondRoundActivities = widget.sndRoundActivities;
  var maxOccurrence = 0;
  var i = 0;
  var popularActivities = [];
  List<Map<dynamic, dynamic>> data = [];
  late String finalActivity = widget.mostFinalActivity;

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  @override
  void initState() {
    if (finalActivity.isEmpty) {
      while (i < listOfSecondRoundActivities.length) {
        var number = listOfSecondRoundActivities[i];
        var occurrence = 1;
        for (int j = 0; j < listOfSecondRoundActivities.length; j++) {
          if (j == i) {
            continue;
          } else if (number == listOfSecondRoundActivities[j]) {
            occurrence++;
          }
        }
        listOfSecondRoundActivities.removeWhere((it) => it == number);
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                SizedBox(height: 400,),
        Container(
          child: ElevatedButton(
            onPressed: () async{
              final url = Uri.parse(
                'https://www.google.com/search?q=${finalActivity}+${widget.location}+${widget.time}',
              );
              firestoreMethods.addTheMostFinalActivity(finalActivity, widget.activitiyUid, url);

              if (await canLaunchUrl(url)) {
              launchUrl(url);
              } else {
              // ignore: avoid_print
              print("Can't launch $url");
              }
            },
            child: Text("See Wassuuuup",style: TextStyle(fontSize: 40),),
          ),
        ),
      ],
    );
  }
}
