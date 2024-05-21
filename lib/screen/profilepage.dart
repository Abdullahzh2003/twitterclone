import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';
import 'package:twitterclone/screen/editprofile.dart';

import 'package:twitterclone/widget.dart/menuprofile.dart';

class Profilepage extends StatefulWidget {
  const Profilepage(this.changescreen, {super.key});
  final Function(String) changescreen;
  // final int follower;
  // final int following;
  @override
  State<Profilepage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profilepage> {
  String? nameOfuser;
  String? dob;
  String? username;
  String? bio;
  Future<void> getnameetc() async {
    final data = await getdata();
    nameOfuser = data!['name'];
    dob = data['dob'];
    username = data['username'];
    bio = data['bio'];
  }

  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the method to initialize data
  }

  void _initializeData() async {
    await getnameetc();
    setState(() {});
  }

  void updateProfile(String newName, String newDob, String bio1) {
    setState(() {
      nameOfuser = newName;
      dob = newDob;
      bio = bio1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return Scaffold(
      backgroundColor: bcolor,
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Container(
                        height: 35,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: tcolor.withOpacity(0.5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return editprofile(
                                  nameOfuser ?? " ",
                                  dob ?? " ",
                                  updateProfile,
                                  bio ?? " ",
                                );
                              },
                              fullscreenDialog: true,
                            ));
                          },
                          child: Text(
                            "Edit profile",
                            style: TextStyle(color: tcolor, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          nameOfuser ?? " ",
                          style: TextStyle(color: tcolor, fontSize: 12),
                        ),
                        Text(username == null ? " " : "@$username",
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w200,
                              fontSize: 8,
                              color: tcolor.withOpacity(0.4),
                            )),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " | $bio |  ",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: tcolor.withOpacity(0.5),
                                      fontSize: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: tcolor.withOpacity(0.7),
                                        size: 15,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        " ${dob ?? ""}",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: tcolor.withOpacity(0.7),
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        " 0 follower",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: tcolor.withOpacity(0.7),
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "0 following",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: tcolor.withOpacity(0.7),
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  menuprofile(nameOfuser ?? " ", username ?? " "),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: 10,
              child:
                  profilecircleuser(30, FirebaseAuth.instance.currentUser!.uid),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 750,
              left: 10,
              child: Container(
                height: 35,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    widget.changescreen("home");
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
