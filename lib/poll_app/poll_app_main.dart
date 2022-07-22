import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/poll_app/poll_auth/poll_welcome.dart';
import 'package:tiktokclone/poll_app/poll_pages/poll_home.dart';
import 'package:tiktokclone/poll_app/poll_services/poll_provider/poll_provider.dart';
import 'package:tiktokclone/poll_app/poll_utils/poll_colors.dart';


class PollAppMain extends StatefulWidget {
  const PollAppMain({Key? key}) : super(key: key);


  @override
  State<PollAppMain> createState() => _PollAppMainState();
}

class _PollAppMainState extends State<PollAppMain> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => PollsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: AppColors.primaryColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return PollHome();
            } else {
              return PollWelcome();
            }
          },
        ),
      ),
    );
  }
}

