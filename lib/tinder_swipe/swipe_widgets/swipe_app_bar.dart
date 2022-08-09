import 'package:flutter/material.dart';
import 'package:tiktokclone/poll_app/poll_app_main.dart';
import 'package:tiktokclone/tinder_swipe/create_group_activity.dart';
import 'package:tiktokclone/tinder_swipe/swipe_widgets/buttom_widget.dart';
import 'package:tiktokclone/tinder_swipe/swipe_widgets/image_widget.dart';

class SwipeTopBar extends StatefulWidget {
  const SwipeTopBar({Key? key}) : super(key: key);

  @override
  State<SwipeTopBar> createState() => _SwipeTopBarState();
}

class _SwipeTopBarState extends State<SwipeTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ConfirmationScreen()));
              },
              child: Text("polling"))

          // buttonWidget(Icons.star, Colors.amber),
          // imageWidget('assets/logo@2x.png'),
          // imageWidget('assets/diamond.png'),
          //
          // buttonWidget(Icons.notifications_active_outlined, Colors.grey.shade400),
        ],
      ),
    );
  }
}
