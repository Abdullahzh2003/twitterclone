import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';
import 'package:twitterclone/pages/mainpages.dart';
import 'package:twitterclone/pages/notificationpage.dart';
import 'package:twitterclone/pages/search.dart';

import 'package:twitterclone/screen/profilepage.dart';

import 'package:twitterclone/widget.dart/bottomhome.dart';
import 'package:twitterclone/widget.dart/drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late int follower;
  late int folowing;
  String flag = "home";

  bool check = true;
  Widget? content;
  Widget? profilecircle;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget? appbar1;
  bool flag3 = true;
  void homechange(bool flag) {
    check = flag;

    setState(() {});
  }

  void changescreen(String flag1) {
    flag = flag1;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool profile = false;
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    if (flag == "home") {
      content = const mainpage();
    } else if (flag == "search") {
      content = const searchpage();
    } else if (flag == "notification") {
      content = const notificationpage();
    } else if (flag == "profile") {
      profile = true;
      content = Profilepage(changescreen);
    } else {
      content = Center(
          child: Text(
        "Message",
        style: TextStyle(color: tcolor),
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: bottomhome(changescreen),
        drawer: SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.2,
                  sigmaY: 1.2,
                ),
                child: const SizedBox.expand(),
              ),
              drawer(changescreen)
            ],
          ),
        ),
        backgroundColor: bcolor,
        body: profile
            ? content
            : Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 30), child: content),
                  Positioned(
                    top: 30,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: profilecircleuser(
                          15, FirebaseAuth.instance.currentUser!.uid),
                    ),
                  )
                ],
              ));
  }
}
