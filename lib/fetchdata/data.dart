import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String getlogoimg(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark
      ? 'assest/dark.jpg'
      : 'assest/light.jpg';
}

Color getbcolor(BuildContext context) {
  // Check if the platform brightness is dark
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    // If dark, return black
    return Colors.black;
  } else {
    // If light, return white
    return Colors.white;
  }
}

Color gettcolor(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}

Widget getappbar(BuildContext context, Widget abc, bool flag) {
  Color bcolor = getbcolor(context);
  Color tcolor = gettcolor(context);
  return Scaffold(
      backgroundColor: bcolor,
      appBar: AppBar(
        automaticallyImplyLeading: flag ? false : true,
        backgroundColor: bcolor,
        title: Center(child: Image.asset(getlogoimg(context))),
        flexibleSpace: flag
            ? Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: tcolor,
                      fontSize: 12,
                    ),
                  ),
                ))
            : null,
      ),
      body: abc);
}

class MessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var firstOffset = Offset(size.width * 0.1, size.height);
    var secondPoint = Offset(size.width * 0.15, size.height * 0.5);
    var lastPoint = Offset(size.width * 0.2, size.height);
    var path = Path()
      ..moveTo(firstOffset.dx, firstOffset.dy)
      ..lineTo(secondPoint.dx, secondPoint.dy)
      ..lineTo(lastPoint.dx, lastPoint.dy)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

Future<String?> getUserProfileImageUrl() async {
  String? imageUrl;

  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Query Firestore to get user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Extract image URL from document data
      imageUrl = userDoc.get('image_url');
    }
  } catch (e) {
    print('Error retrieving profile image URL: $e');
  }
  print("$imageUrl 0000000000000000000000000000000");
  return imageUrl;
}

Future<String?> _profileImageUrlFuture = getUserProfileImageUrl();

Widget profilecircle(double a) {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      print('user is signed out');
    } else {
      // handle fetching user data

      print('user has signed in');
    }
  });

  return FutureBuilder<String?>(
    future: _profileImageUrlFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircleAvatar(
          radius: a,
          backgroundColor: Colors.grey,
        );
      } else if (snapshot.hasData && snapshot.data != null) {
        return CircleAvatar(
          radius: a,
          backgroundImage: NetworkImage(snapshot.data!),
        );
      } else {
        // print(FirebaseAuth.instance.currentUser!.uid);
        return CircleAvatar(
          radius: a,
          backgroundColor: Colors.grey,
        );
      }
    },
  );
}

Future<Map<String, dynamic>?> getdata() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  if (data != null) {
    return data;
  } else {
    throw Exception('Data not found');
  }
}
