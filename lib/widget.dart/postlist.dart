import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twitterclone/widget.dart/postdetail.dart';

class postlistscreen extends StatefulWidget {
  const postlistscreen({super.key});

  @override
  State<postlistscreen> createState() => _postlistscreenState();
}

class _postlistscreenState extends State<postlistscreen> {
  List<DocumentSnapshot> documentsList = [];
  Future<void> fetchData() async {
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('post');

    QuerySnapshot querySnapshot = await postsRef.get();

    documentsList = querySnapshot.docs.toList();
    // documentsList.shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 155,
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 155,
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 155,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: documentsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot post = documentsList[index];
                String postId = post.id;
                return postdetail(postId, post);
              },
            ),
          );
        }
      },
    );
  }
}
