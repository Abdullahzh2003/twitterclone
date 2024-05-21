import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';
import 'package:twitterclone/widget.dart/postattribute.dart';
import 'package:twitterclone/widget.dart/singlepost.dart';

class postdetail extends StatefulWidget {
  postdetail(this.postId, this.post, {super.key});
  final DocumentSnapshot post;
  final String postId;
  @override
  State<postdetail> createState() => _postdetailState();
}

class _postdetailState extends State<postdetail> {
  bool checkimg = false;
  bool checklike = false;
  late int likecount;
  @override
  void initState() {
    super.initState();
    checkimg = widget.post['media'] != 'null';
    likecount = widget.post['likecount'];
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Hero(
      tag: widget.postId,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
            child: Row(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    profilecircleuser(15, widget.post['userid']),
                  ],
                ),
                const SizedBox(
                  width: 4,
                ),
                FutureBuilder(
                  future: getUserDetails(widget.post['userid']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: Row(
                          children: [
                            Container(
                              color: Colors.grey.withOpacity(0.4),
                              width: 100,
                              height: 10,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                              color: Colors.grey.withOpacity(0.3),
                              width: 50,
                              height: 8,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Flexible(
                        child: Row(
                          children: [
                            Text(
                              snapshot.data!['name']!,
                              style: TextStyle(
                                color: tcolor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              " @${snapshot.data!['username']!}",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w200,
                                fontSize: 8,
                                color: tcolor.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                                " .${formatRelativeTime(widget.post['date'].toDate())} ",
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 8,
                                  color: tcolor.withOpacity(0.3),
                                )),
                          ],
                        ),
                      );
                    } else {
                      return const Text('Error fetching user details');
                    }
                  },
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => singlepost(
                          likecount, checkimg, widget.postId, widget.post)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 52),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post['content'],
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w200,
                        fontSize: 9,
                        color: tcolor,
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  if (checkimg)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 10, right: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.grey.withOpacity(0.4), // Grey background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.post['media']!,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                // Image has finished loading, so return the image
                                return child;
                              } else {
                                // Image is still loading, so return the grey container as a placeholder
                                return Container(
                                  color: Colors.grey,
                                  width: 300,
                                  height: 200,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          postattribute(likecount, widget.postId, widget.post),
          const SizedBox(
            height: 6,
          ),
          Container(
            color: tcolor.withOpacity(0.1),
            width: double.infinity,
            height: 1,
          ),
        ],
      ),
    );
  }
}
