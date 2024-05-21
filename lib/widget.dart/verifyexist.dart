import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twitterclone/screen/homepage.dart';

class verifyexist extends StatefulWidget {
  const verifyexist(this.changekrdo, {super.key});
  final void Function(bool, String) changekrdo;

  @override
  State<verifyexist> createState() => _verifyexistState();
}

class _verifyexistState extends State<verifyexist> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
  }

  RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<List<dynamic>> isEmailExists(String email) async {
    var querySnapshot;
    try {
      // Query Firestore to check if the email exists
      if (emailRegExp.hasMatch(emailcontroller.text.trim())) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        return [querySnapshot.docs.isNotEmpty, false];
      } else {
        var usernameSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: email)
            .get();
        return [false, usernameSnapshot.docs.isNotEmpty];
      }
      // If there are any documents returned, the email exists
    } catch (e) {
      print("Error checking email existence: $e");
      // Handle any errors that occur during the check
      return [false, false];
    }
  }

  void onnext() async {
    if (emailcontroller.text.trim().isEmpty) {
      return;
    }
    final checkcredential = await isEmailExists(emailcontroller.text);
    if (checkcredential[0] == false && checkcredential[1] == false) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ))
              ],
              content: const Text(
                'Account not exist on this email/username',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            );
          });
      widget.changekrdo(false, "");
    }
    if (checkcredential[0] == true && checkcredential[1] == false) {
      widget.changekrdo(true, emailcontroller.text);
    } else {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: emailcontroller.text)
          .get();

      final userData = querySnapshot.docs.first.data();

      widget.changekrdo(true, userData['email']);
      changekro();
    }
  }

  void changekro() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
      (route) => false, // This function ensures that all routes are removed
    );
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To get started, first enter your phone, email, or @username",
              style: TextStyle(
                color: tcolor,
                fontSize: 18,
              ),
            ),
            TextField(
              style: TextStyle(color: tcolor),
              controller: emailcontroller,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: tcolor), // Change the color of the bottom line
                ),
                label: Text(
                  "Phone, email, or username",
                  style: TextStyle(color: tcolor, fontSize: 12),
                ),
              ),
            ),
            const Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forget Password?",
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onnext,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                    ),
                  )
                ])),
          ]),
    );
  }
}
