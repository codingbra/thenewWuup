import 'package:flutter/material.dart';
import 'package:tiktokclone/tinder_swipe/swipe_widgets/buttom_widget.dart';

// maybe i can overtake some parts from here for in app messages.
actions(BuildContext context, String name, type) { // here actions are set
  showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog( // from material
          content: buttonWidget(
              type == 'Liked' // if type = liked else - rejected
                  ? Icons.favorite // if else
                  : type == 'Rejected'
                  ? Icons.close
                  : Icons.star,
              type == 'Liked'
                  ? Colors.pink
                  : type == 'Rejected'
                  ? Colors.red
                  : Colors.blue),
          title: Text(
            'You ${type} ${name}', // you "liked" "name of activity"
            style: TextStyle(
                color: type == 'Liked'
                    ? Colors.pink
                    : type == 'Rejected'
                    ? Colors.red
                    : Colors.blue),
          ),
        );
      });
}