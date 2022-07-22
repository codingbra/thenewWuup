

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



User? currUser = FirebaseAuth.instance.currentUser;




saveDecision(Map pollsWeights, String title) async{
  await FirebaseFirestore.instance.collection("decisions").
  add({
    "title" : title,
    "pollWeights" : pollsWeights,
    "uid" : currUser!.uid,
    "Date" : Timestamp.now(),
  });
}