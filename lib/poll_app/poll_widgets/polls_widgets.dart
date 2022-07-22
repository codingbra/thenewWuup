import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tiktokclone/poll_app/poll_services/functions/poll_firebase_functions.dart';
import 'package:tiktokclone/poll_app/poll_services/poll_provider/poll_provider.dart';
import 'package:tiktokclone/poll_app/poll_utils/poll_colors.dart';


class PollsContainer extends StatefulWidget {
  const PollsContainer({Key? key}) : super(key: key);

  @override
  State<PollsContainer> createState() => _PollsContainerState();
}

class _PollsContainerState extends State<PollsContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PollsProvider>(
        builder: (context, model, child) => Card(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Add Title",
                                hintStyle: TextStyle(
                                  fontSize: 18
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none
                                )
                              ),
                          textCapitalization: TextCapitalization.sentences,
                          cursorColor: AppColors.primaryColor,
                          maxLines: 2,
                          minLines: 1,
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Enter Title";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            model.addPollTitle(value!);
                          },
                        ))
                      ],
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < model.pollsOptions.length; i++)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      model.removeOption();
                                    }, icon: Icon(Icons.close)),

                                Expanded(child: TextFormField(
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Enter Title";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value){
                                    model.pollsOptions[i] = value!;
                                    model.pollsWeights[value] = 0;
                                  },
                                ))
                              ],
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: (){

                              model.addPollOption();
                            },
                            child: Text("Add an option"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}

class PollsWidget extends StatefulWidget {
  final String decisionId,decisionTitle,creatorId;
  final Map pollWeights, usersWhoVoted;

  const PollsWidget({Key? key,
    required this.decisionTitle,
    required this.decisionId,
    required this.creatorId,
    required this.usersWhoVoted,
    required this.pollWeights
  }) : super(key: key);

  @override
  State<PollsWidget> createState() => _PollsWidgetState();
}

class _PollsWidgetState extends State<PollsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        shadowColor: Colors.grey.shade700.withOpacity(0.2),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade700.withOpacity(0.3))
        ),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(child: Text(widget.decisionTitle
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

