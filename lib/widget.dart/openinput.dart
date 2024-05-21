import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/blueprint/post.dart';
import 'package:twitterclone/fetchdata/data.dart';

class openinputscreen extends StatefulWidget {
  openinputscreen({Key? key}) : super(key: key);

  @override
  State<openinputscreen> createState() => _OpenInputScreenState();
}

class _OpenInputScreenState extends State<openinputscreen> {
  late post postdetail;
  File? _selectedimg;
  void takepicture() async {
    final imagepicker = ImagePicker();
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedimg = File(pickedImage.path);
    });
  }

  double lengthCircle = 0;
  String? endlength;
  TextEditingController postcontroller = TextEditingController();
  Future<void> onsaved() async {
    // Generate a random number between 100 and 999 (inclusive)
    postdetail = post(
        media: _selectedimg == null ? null : _selectedimg!.path,
        content: postcontroller.text,
        LikeList: [],
        likecount: 0,
        Listofcomment: [],
        userid: FirebaseAuth.instance.currentUser!.uid);

    try {
      String imgurl = 'abc';

      final Storageref = FirebaseStorage.instance
          .ref()
          .child('post_imges')
          .child('${postdetail.postId}.jpg');
      if (_selectedimg != null) {
        await Storageref.putFile(_selectedimg!);
        imgurl = await Storageref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('post')
          .doc(postdetail.postId)
          .set({
        'media': _selectedimg == null ? 'null' : imgurl,
        'content': postdetail.content,
        'likelist': postdetail.LikeList,
        'likecount': postdetail.likecount,
        'listComment': postdetail.Listofcomment,
        'repostcount': 0,
        'userid': postdetail.userid,
        'date': postdetail.Date
      });
      Navigator.pop(context);
    } catch (e) {}
  }

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the Scaffold resizes when the keyboard appears
      backgroundColor: bcolor,
      appBar: AppBar(
        leadingWidth: 80,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: EdgeInsets.only(left: 0.0, bottom: 0.0, top: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: tcolor, fontSize: 12),
              ),
            ),
          ),
        ),
        backgroundColor: bcolor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: flag
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(
                            75, 5), // Adjust the width and height as needed
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 20), // Adjust padding as needed
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Change the value to adjust the roundness
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) {
                          // Return the default color
                          return const Color.fromARGB(255, 14, 136,
                              230); // Change to the color you want
                        },
                      ),
                    ),
                    onPressed: () {
                      if (postcontroller.text != '') {
                        flag = true;
                        setState(() {});
                        onsaved();
                      }
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: tcolor.withOpacity(0.7), fontSize: 10),
                    ),
                  ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    profilecircle(15),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, top: 5),
                      child: TextField(
                        controller: postcontroller,
                        // readOnly: lengthCircle >= 1 ? true : false,
                        onChanged: (value) {
                          setState(() {
                            lengthCircle = (value.length * 0.36) / 100;
                          });
                        },
                        maxLength: 280,
                        style: TextStyle(color: tcolor, fontSize: 12),
                        keyboardType: TextInputType.multiline,
                        maxLines: null, // Allow multiple lines of input
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    bcolor), // Change the color of the focused bottom line
                          ),
                          hintText: "write your Through",
                          hintStyle: TextStyle(
                              color: tcolor.withOpacity(0.6), fontSize: 12),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    bcolor), // Change the color of the bottom line
                          ),
                        ), // Change the color of the bottom line
                      ),
                    ),
                  ],
                ),
                if (_selectedimg != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(_selectedimg!),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: takepicture,
                        icon: const Icon(
                          Icons.insert_photo_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.location_on_sharp,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif_box_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.poll,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: 1.5, // Adjust width as needed
                        height: 24, // Adjust height as needed
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 20, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          color:
                              lengthCircle >= 1.0050 ? Colors.red : Colors.blue,
                          value: lengthCircle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
