import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class singlepostattribute extends StatefulWidget {
  singlepostattribute(this.likecount, this.postId, this.post, {super.key});
  final DocumentSnapshot post;
  final int likecount;
  final String postId;
  @override
  State<singlepostattribute> createState() =>
      _singlepostattributeState(likecount);
}

class _singlepostattributeState extends State<singlepostattribute> {
  _singlepostattributeState(this.likecount);
  bool checklike = false;
  bool checkrepost = false;
  int likecount;
  @override
  void initState() {
    super.initState();

    _initializeCheckLike();
  }

  Future<void> _initializeCheckLike() async {
    bool liked = await checklikebool();
    setState(() {
      checklike = liked;
    });
  }

  Future<bool> checklikebool() async {
    bool abc = false;
    abc = await checkIfUserLikedPost(
        widget.postId, FirebaseAuth.instance.currentUser!.uid);
    return abc;
  }

  Future<bool> checkIfUserLikedPost(String postId, String userId) async {
    try {
      DocumentSnapshot postDoc =
          await FirebaseFirestore.instance.collection('post').doc(postId).get();

      if (!postDoc.exists) {
        print('Document does not exist for postId: $postId');
        return false;
      }

      List<dynamic> likes =
          (postDoc.data() as Map<String, dynamic>?)?['likelist'] ?? [];

      bool userLiked = likes.contains(userId);

      return userLiked;
    } catch (e) {
      print('Error checking if user liked post: $e');
      return false;
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    print('Fetching post document...');
    try {
      DocumentSnapshot postDoc =
          await FirebaseFirestore.instance.collection('post').doc(postId).get();

      if (!postDoc.exists) {
        print('Document does not exist for postId: $postId');
        return;
      }

      List<dynamic> likes =
          (postDoc.data() as Map<String, dynamic>?)?['likelist'] ?? [];

      bool userLiked = likes.contains(userId);

      if (userLiked) {
        likes.remove(userId);
        checklike = false;
        likecount--;
      } else {
        likes.add(userId);
        checklike = true;
        likecount++;
      }
      int likeCount = likes.length;
      await FirebaseFirestore.instance.collection('post').doc(postId).update({
        'likelist': likes,
        'likecount': likeCount,
      });

      print('Like toggled successfully.');
      setState(() {});
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16),
          child: Flexible(
            child: Text(
                " ${DateFormat('h:mm a d/M/y').format(widget.post['date'].toDate())} ",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w200,
                  fontSize: 9,
                  color: tcolor.withOpacity(0.8),
                )),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Container(
            color: tcolor.withOpacity(0.15),
            width: double.infinity,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 36.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${likecount}",
                style: TextStyle(
                  fontSize: 10,
                  color: tcolor,
                ),
              ),
              Text(
                " Likes",
                style: TextStyle(
                  fontSize: 10,
                  color: tcolor.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            color: tcolor.withOpacity(0.15),
            width: double.infinity,
            height: 1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                toggleLike(
                    widget.postId, FirebaseAuth.instance.currentUser!.uid);
              },
              icon: Icon(
                checklike ? Icons.favorite : Icons.favorite_border_outlined,
                color: checklike
                    ? Colors.pink.withOpacity(0.8)
                    : tcolor.withOpacity(0.4),
                size: 14,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.comment,
                color: tcolor.withOpacity(0.4),
                size: 14,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.repeat,
                color: tcolor.withOpacity(0.4),
                size: 14,
              ),
            ),
            Icon(
              Icons.bookmark_add_outlined,
              color: tcolor.withOpacity(0.4),
              size: 16,
            ),
          ],
        ),
      ],
    );
  }
}
