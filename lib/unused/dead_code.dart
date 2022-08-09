// CollectionReference secondRoundActivityConfirmation = firestore.collection("groups");
// var doc = secondRoundActivityConfirmation.doc(widget.activitiyUid).collection("secondRoundMainActivity").get();
// print(doc);
//
// checkFor2ndRoundActivity();
//
// if(doesExist){
//  // finalActivity = checkFor2ndRoundActivity().toString();
//   print("does it exist ? ${doesExist}");
//   print("this is the final activity from FB{$finalActivity}");
//   finalActivity = checkFor2ndRoundActivity().toString();
//
// } else {

// Future<String> checkFor2ndRoundActivity() async {
//
//
//   await FirebaseFirestore.instance
//       .collection('groups')
//       .doc(widget.activitiyUid)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       String secondRoundActivity =
//       documentSnapshot.get(FieldPath(["secondRoundMainActivity"]));
//       // for(var elements in nested) {
//       //   chosenActivities.add(elements);
//       // }
//       finalActivity = secondRoundActivity;
//
//       print("these are the user that have voted ${finalActivity}");
//       doesExist = true;
//     } else {
//       print('Document does not exist on the database');
//       doesExist = false;
//     }
//   });
//   print(doesExist);
//   return finalActivity;
// }