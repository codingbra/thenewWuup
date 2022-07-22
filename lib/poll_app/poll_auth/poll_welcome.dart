import 'package:flutter/material.dart';

class PollWelcome extends StatefulWidget {
  const PollWelcome({Key? key}) : super(key: key);

  @override
  State<PollWelcome> createState() => _PollWelcomeState();
}

class _PollWelcomeState extends State<PollWelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Decision App"),
        ),
      ),
    );
  }
}
