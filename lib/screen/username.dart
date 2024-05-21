import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:twitterclone/blueprint/user.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/screen/homepage.dart';

class username extends StatefulWidget {
  const username(this.email, this.userdetail, this._selectedimg, this.password,
      {super.key});
  // final Function(File, String) onsaved;
  final File _selectedimg;
  final String email;
  final String password;
  final user userdetail;

  @override
  State<username> createState() => _usernameState();
}

class _usernameState extends State<username> {
  bool containsNumericAndText(String input) {
    RegExp regex = RegExp(r'\d.*[a-zA-Z]|[a-zA-Z].*\d');
    return regex.hasMatch(input);
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  bool onpress = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernamecontroller.dispose();
  }

  Future<void> onsaved(File img, String username) async {
    Random random = Random();

    // Generate a random number between 100 and 999 (inclusive)
    int randomNumber = random.nextInt(900) + 100;
    try {
      // print("fjhndjfsdkkkkkkkkkkkkkkkkkkkkkkk");
      final UserCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: widget.password);

      final Storageref = FirebaseStorage.instance
          .ref()
          .child('user_imges')
          .child('${UserCredential.user!.uid}.jpg');
      await Storageref.putFile(img);
      final imgurl = await Storageref.getDownloadURL();
      widget.userdetail.imgurl = imgurl;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(UserCredential.user!.uid)
          .set({
        'name': widget.userdetail.name,
        'dob': widget.userdetail.dob!,
        'username': username == ""
            ? "${widget.userdetail.name!.substring(0, 3)}$randomNumber"
            : username,
        'email': widget.email,
        'image_url': widget.userdetail.imgurl,
        'likepost': [],
        'bio': widget.userdetail.bio,
        'followlist': [],
        'followinglist': [],
        'postlist': []
      });
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => Homepage()),
      //   (route) => false, // This function ensures that all routes are removed
      // );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
        (route) => false, // This function ensures that all routes are removed
      );
    } on FirebaseAuthException catch (error) {
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
              content: Text(
                error.code,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return getappbar(
        context,
        Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What should we call you?",
                  style: TextStyle(color: tcolor, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Your @username is unique. You can always change it later.",
                  style: TextStyle(color: tcolor.withOpacity(0.5), fontSize: 9),
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formkey,
                  child: TextFormField(
                      controller: usernamecontroller,
                      validator: (value) {
                        if (!containsNumericAndText(value!) ||
                            value.trim().isEmpty) {
                          return 'Username must contain Alphabat and numeric value';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  tcolor), // Change the color of the bottom line
                        ),
                        label: Text(
                          "Username",
                          style: TextStyle(
                              color: tcolor.withOpacity(0.7), fontSize: 12),
                        ),
                      )),
                ),
                const Spacer(),
                if (onpress) Center(child: CircularProgressIndicator()),
                if (!onpress)
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        if (!onpress) {
                          onpress = true;
                          setState(() {});
                          onsaved(widget._selectedimg, usernamecontroller.text);
                        }
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 35,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: const Color.fromARGB(156, 224, 227, 229),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 15, 14, 14)
                                    .withOpacity(0.5),
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (!onpress)
                  GestureDetector(
                    onTap: () {
                      if (!onpress) {
                        onpress = true;
                        setState(() {});
                        onsaved(widget._selectedimg, "");
                      }
                    },
                    child: Center(
                      child: Text(
                        "Skip for now",
                        style: TextStyle(
                            color: tcolor,
                            fontSize: 12,
                            decorationColor: tcolor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
              ],
            )),
        false);
  }
}
