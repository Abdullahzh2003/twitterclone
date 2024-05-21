import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:twitterclone/blueprint/post.dart';

import 'package:twitterclone/widget.dart/postdetail.dart';

class menuprofile extends StatefulWidget {
  const menuprofile(this.name, this.username, {Key? key}) : super(key: key);
  final String name;
  final String username;

  @override
  State<menuprofile> createState() => _MenuprofileState();
}

class _MenuprofileState extends State<menuprofile> {
  double? bluelineori = 33;
  int abc = 1;
  String? swipeDirection;
  post? postDetail;
  List postlist = [];
  final List<TextEditingController> _controllers = [];
  late Stream<QuerySnapshot> postStream;

  @override
  void initState() {
    super.initState();
    postStream = fetchData();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // Remaining code...

  Stream<QuerySnapshot> fetchData() {
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('post');

    return postsRef
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        // .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    if (abc == 1) {
      bluelineori = 33;
    }
    if (abc == 2) {
      bluelineori = 110;
    }
    if (abc == 4) {
      bluelineori = MediaQuery.of(context).size.width - 80;
    }
    if (abc == 3) {
      bluelineori = 190;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  abc = 1;
                  setState(() {});
                },
                child: Text(
                  "Post",
                  style: TextStyle(color: tcolor, fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  abc = 2;
                  setState(() {});
                },
                child: Text(
                  "Reply",
                  style: TextStyle(color: tcolor, fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  abc = 3;
                  setState(() {});
                },
                child: Text(
                  "Media",
                  style: TextStyle(color: tcolor, fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  abc = 4;
                  setState(() {});
                },
                child: Text(
                  "Likes",
                  style: TextStyle(color: tcolor, fontSize: 10),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: bluelineori),
              Container(
                width: 50,
                height: 1.5,
                color: Colors.blue,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.5,
            color: Colors.grey.withOpacity(0.5),
          ),
          StreamBuilder(
            stream: postStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data!.docs.isNotEmpty) {
                  List<DocumentSnapshot> documentsList = snapshot.data!.docs;
                  List<DocumentSnapshot> filteredList =
                      documentsList.where((post1) {
                    return post1['media'] != 'null';
                  }).toList();

                  return SizedBox(
                    height: 345,
                    child: ListView.builder(
                      itemCount:
                          abc == 3 ? filteredList.length : documentsList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot post = abc == 3
                            ? filteredList[index]
                            : documentsList[index];
                        String postId = post.id;
                        return postdetail(postId, post);
                      },
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 345,
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
