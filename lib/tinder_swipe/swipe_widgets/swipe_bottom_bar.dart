import 'package:flutter/material.dart';
import 'package:tiktokclone/tinder_swipe/swipe_widgets/buttom_widget.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _SwipeTopBarState();
}

class _SwipeTopBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttonWidget(Icons.refresh, Colors.amber,),
          buttonWidget(Icons.close, Colors.red,),
          buttonWidget(Icons.star, Colors.blue,),
          buttonWidget(Icons.favorite_outline_outlined, Colors.pink,),
          buttonWidget(Icons.bolt, Colors.purple,),
        ],
      ),
    );
  }
}
