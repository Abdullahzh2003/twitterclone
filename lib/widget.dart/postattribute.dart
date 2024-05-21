import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class postattribute extends StatefulWidget {
  postattribute(this.likecount, this.postId, this.post, {super.key});
  final DocumentSnapshot post;
  final int likecount;
  final String postId;
  @override
  State<postattribute> createState() => _postattributeState(likecount);
}

class _postattributeState extends State<postattribute> {
  _postattributeState(this.likecount);
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () async {
            toggleLike(widget.postId, FirebaseAuth.instance.currentUser!.uid);
          },
          icon: Icon(
            checklike ? Icons.favorite : Icons.favorite_border_outlined,
            color: checklike
                ? Colors.pink.withOpacity(0.8)
                : tcolor.withOpacity(0.4),
            size: 14,
          ),
          label: Text(
            "${likecount}",
            style: TextStyle(
              fontSize: 8,
              color: checklike
                  ? Colors.pink.withOpacity(0.8)
                  : tcolor.withOpacity(0.4),
            ),
          ),
        ),
        TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.comment,
              color: tcolor.withOpacity(0.4),
              size: 14,
            ),
            label: Text(
              "${widget.post['listComment'].length}",
              style: TextStyle(fontSize: 8, color: tcolor.withOpacity(0.4)),
            )),
        TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.repeat,
              color: tcolor.withOpacity(0.4),
              size: 14,
            ),
            label: Text(
              "${widget.post['repostcount']}",
              style: TextStyle(fontSize: 8, color: tcolor.withOpacity(0.4)),
            )),
        Icon(
          Icons.bookmark_add_outlined,
          color: tcolor.withOpacity(0.4),
          size: 16,
        ),
      ],
    );
  }
}
