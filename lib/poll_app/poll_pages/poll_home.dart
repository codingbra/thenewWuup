import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/poll_app/poll_pages/poll_add_decision.dart';
import 'package:tiktokclone/poll_app/poll_pages/poll_dashboard.dart';
import 'package:tiktokclone/poll_app/poll_utils/poll_colors.dart';

class PollHome extends StatefulWidget {
  const PollHome({Key? key}) : super(key: key);

  @override
  State<PollHome> createState() => _PollHomeState();
}

class _PollHomeState extends State<PollHome> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index){
    setState((){
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poll App "),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [Dashboard(), AddDecision()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Decision")
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey.shade700,
        onTap: onTapped,

      ),
    );
  }
}
