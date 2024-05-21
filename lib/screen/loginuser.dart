import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/widget.dart/comlogin.dart';
import 'package:twitterclone/widget.dart/verifyexist.dart';

class loginuser extends StatefulWidget {
  const loginuser({super.key});

  @override
  State<loginuser> createState() => _loginuserState();
}

class _loginuserState extends State<loginuser> {
  bool flag = false;
  String email = "";

  void changemode(bool a, String email1) {
//if email exist then ask for password else show a menu that account not found
    flag = a;
    email = email1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getappbar(
        context, flag ? comlogin(email) : verifyexist(changemode), true);
  }
}
