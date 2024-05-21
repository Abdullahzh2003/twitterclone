import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';

class editprofile extends StatefulWidget {
  const editprofile(this.nameuser, this.dob, this.update, this.bio,
      {super.key});
  final String nameuser;
  final String dob;
  final Function(String, String, String) update;
  final String bio;

  @override
  State<editprofile> createState() => _EditProfileState();
}

class _EditProfileState extends State<editprofile> {
  // File? _selectedProfile;
  // File? _selectedCover;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  String dob1 = " ";
  String? bio;
  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
  }

  void takepicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    } else {
      File imageFile = File(pickedImage.path);
      updateProfile(imageFile);
    }
  }

  Future<void> updateProfile(File img) async {
    try {
      final user1 = FirebaseAuth.instance.currentUser;
      if (user1 != null) {
        // Delete previous image from storage
        String prevImgUrl = user1.photoURL ?? "";
        if (prevImgUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(prevImgUrl).delete();
        }

        // Upload new image to storage
        final Storageref = FirebaseStorage.instance
            .ref()
            .child('user_imges')
            .child('${user1.uid}.jpg');
        await Storageref.putFile(img);
        final imgurl = await Storageref.getDownloadURL();

        // Update user's photo URL
        await user1.updatePhotoURL(imgurl);

        // Update user's profile in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user1.uid)
            .update({
          'image_url': imgurl,
        });
      }
      setState(() {});
    } catch (e) {
      print("Error updating profile: $e");
      // Handle error here
    }
  }

  void saveinput() async {
    final String newName = namecontroller.text;
    final User? user = FirebaseAuth.instance.currentUser;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    if (newName != widget.nameuser) {
      // Update the name field in the document
      await userRef.update({
        'name': newName,
      });
    }
    if (dob1 != widget.dob) {
      await userRef.update({
        'dob': dob1,
      });
    }

    await userRef.update({
      'bio': biocontroller.text,
    });

    widget.update(newName, dob1, biocontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    if (namecontroller.text == '') {
      namecontroller.text = widget.nameuser;
    }
    if (biocontroller.text == '') {
      biocontroller.text = bio ?? " ";
      // Use widget.bio if not null, otherwise use an empty string
    }
    return Scaffold(
        backgroundColor: bcolor,
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                saveinput();
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: TextStyle(color: tcolor, fontSize: 12),
              ),
            )
          ],
          title: Text(
            "             Edit Profile",
            style: TextStyle(color: tcolor, fontSize: 15),
          ),
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: tcolor, fontSize: 8),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: tcolor),
                          controller: namecontroller,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bcolor), // Change the color of the border when focused
                            ),
                            label: Text(
                              "Name",
                              style: TextStyle(color: tcolor, fontSize: 10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bcolor), // Change the color of the bottom line
                            ),
                          ),
                        ),
                        Divider(
                          color: tcolor.withOpacity(
                              0.5), // You can change the color as per your requirement
                          thickness: 1,

                          // You can change the thickness as per your requirement
                        ),
                        SizedBox(
                          height: 120,
                          child: TextFormField(
                            style: TextStyle(color: tcolor),
                            maxLength: 40,
                            maxLines: null,
                            controller: biocontroller,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        bcolor), // Change the color of the border when focused
                              ),
                              focusColor: bcolor,
                              label: Text(
                                "Bio",
                                style: TextStyle(color: tcolor, fontSize: 10),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        bcolor), // Change the color of the bottom line
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: tcolor.withOpacity(
                              0.5), // You can change the color as per your requirement
                          thickness: 1,

                          // You can change the thickness as per your requirement
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bcolor), // Change the color of the border when focused
                            ),
                            label: Text(
                              "Location",
                              style: TextStyle(color: tcolor, fontSize: 10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bcolor), // Change the color of the bottom line
                            ),
                          ),
                        ),
                        Divider(
                          color: tcolor.withOpacity(
                              0.5), // You can change the color as per your requirement
                          thickness: 1,

                          // You can change the thickness as per your requirement
                        ),
                        Row(
                          children: [
                            Text(
                              "Birth Date",
                              style: TextStyle(color: tcolor, fontSize: 10),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  DateTime? picked1 = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2020),
                                      initialDate: DateTime(2010));
                                  dob1 = DateFormat('d MMMM, yyyy')
                                      .format(picked1!);
                                  setState(() {});
                                },
                                child: Text(
                                  dob1 == " " ? widget.dob : dob1,
                                  style: TextStyle(color: tcolor, fontSize: 10),
                                ))
                          ],
                        ),
                        Divider(
                          color: tcolor.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ],
                    ))),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 670,
              left: 20,
              child: GestureDetector(
                onTap: takepicture,
                child: Stack(
                  children: [
                    profilecircleuser(
                        30, FirebaseAuth.instance.currentUser!.uid),
                    const Positioned(
                      top: 20,
                      left: 15,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        )));
  }
}
