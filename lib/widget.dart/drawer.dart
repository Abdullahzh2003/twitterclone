import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';

import 'package:twitterclone/screen/startingscreen.dart';
import 'package:twitterclone/widget.dart/drawersub.dart';

class drawer extends StatefulWidget {
  const drawer(this.openprofile, {super.key});
  final Function(String) openprofile;
  @override
  State<drawer> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<drawer> {
  // late int followercount;
  // late int followingcount;
  @override
  Widget build(BuildContext context) {
    String img = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? 'assest/dark.jpg'
        : 'assest/light.jpg';

    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    return Drawer(
      width: MediaQuery.sizeOf(context).width - 100,
      backgroundColor: bcolor,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: tcolor,
                        ),
                      )
                    ],
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // widget.openprofile(
                      //     "profile", followercount, followingcount);
                    },
                    child: profilecircleuser(
                        15, FirebaseAuth.instance.currentUser!.uid),
                  )),
              const SizedBox(
                height: 2,
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: getdata(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            color: Colors.grey.withOpacity(0.4))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data;
                    if (data != null) {
                      // followercount = data['followlist'].length;
                      // followingcount = data['followinglist'].length;
                      return Column(
                        children: [
                          ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(color: tcolor, fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "@${data['username']}",
                                  style: TextStyle(
                                    color: tcolor.withOpacity(0.6),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "0 Following",
                                  style: TextStyle(
                                    color: tcolor.withOpacity(0.6),
                                    fontSize: 8,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "0 Followers",
                                  style: TextStyle(
                                    color: tcolor.withOpacity(0.6),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('No data available');
                    }
                  }
                },
              ),
            ])),
        SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    widget.openprofile("profile");
                  },
                  leading: Icon(
                    Icons.person,
                    color: tcolor,
                  ),
                  titleTextStyle: TextStyle(color: tcolor),
                  title: const Text(
                    "Profile",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                    try {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const startingscreen()),
                        (route) =>
                            false, // This function ensures that all routes are removed
                      );
                      // Log out successful
                    } catch (e) {
                      // Handle any errors that occur during sign out
                      print("Error signing out: $e");
                    }
                  },
                  leading: Image.asset(img),
                  titleTextStyle: TextStyle(color: tcolor),
                  title: const Text(
                    "Premium",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                    try {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const startingscreen()),
                        (route) =>
                            false, // This function ensures that all routes are removed
                      );
                      // Log out successful
                    } catch (e) {
                      // Handle any errors that occur during sign out
                      print("Error signing out: $e");
                    }
                  },
                  leading: Icon(
                    Icons.bookmark_outline,
                    color: tcolor,
                  ),
                  titleTextStyle: TextStyle(color: tcolor),
                  title: const Text(
                    "Bookmark",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                    try {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const startingscreen()),
                        (route) =>
                            false, // This function ensures that all routes are removed
                      );
                      // Log out successful
                    } catch (e) {
                      // Handle any errors that occur during sign out
                    }
                  },
                  leading: Icon(
                    Icons.list_alt_sharp,
                    color: tcolor,
                  ),
                  titleTextStyle: TextStyle(color: tcolor),
                  title: const Text(
                    "Lists",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            const Divider(
              color: Colors.grey, // Change color as needed
              thickness: 1.0, // Change thickness as needed
            ),
            const drawersub()
          ]),
        )),
      ]),
    );
  }
}
