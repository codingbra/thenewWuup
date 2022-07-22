import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/poll_app/poll_services/functions/poll_firebase_functions.dart';
import 'package:tiktokclone/poll_app/poll_services/poll_provider/poll_provider.dart';
import 'package:tiktokclone/poll_app/poll_widgets/polls_widgets.dart';

class AddDecision extends StatefulWidget {
  const AddDecision({Key? key}) : super(key: key);

  @override
  State<AddDecision> createState() => _AddDecisionState();
}

class _AddDecisionState extends State<AddDecision> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Referring to the provider
        body: Consumer<PollsProvider>(
            builder: (context, model, child) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          PollsContainer(),
                          ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  _formKey.currentState!.save();
                                  saveDecision(
                                      model.pollsWeights, model.pollTitle);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Decision Uploaded")));
                              },
                              child: Text("Upload Poll"))
                        ],
                      ),
                    ),
                  ),
                )));
  }
}
