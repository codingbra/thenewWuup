import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/constants.dart';

class GetUserProfilePhoto extends StatelessWidget {
  final String documentId = "";

  GetUserName(String documentId){
    return this.documentId;
}

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(firebaseAuth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Image.network(data["profilePhoto"]);
          //return Text("Full Name: ${data['profilePhoto']} ${data['name']}");
        }
        return Text("loading");
      },
    );
  }
}