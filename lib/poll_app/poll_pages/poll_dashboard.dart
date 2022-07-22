import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/poll_app/poll_widgets/polls_widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return PollsWidget(
                         decisionId: docs[index].id,
                         decisionTitle: docs[index]["title"],
                          creatorId: docs[index]["uid"],
                          pollWeights: docs[index]["pollWeights"],
                          usersWhoVoted: docs[index]['usersWhoVoted'],
                        );
                      },
                      itemCount: docs.length,
                    );
                  }
                },
                stream: FirebaseFirestore.instance
                    .collection("decisions")
                    .snapshots(),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
