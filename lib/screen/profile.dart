import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/blueprint/user.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/screen/username.dart';

class Profile1 extends StatefulWidget {
  const Profile1(this.userdetail, this.email, this.password, {super.key});
  final String password;
  // final Function(File, String) onsaved;
  final String email;
  final user userdetail;
  @override
  State<Profile1> createState() => _ProfileState();
}

class _ProfileState extends State<Profile1> {
  File? _selectedimg;
  void takepicture(bool flag) async {
    final imagepicker = ImagePicker();
    final pickedImage = await imagepicker.pickImage(
        source: flag ? ImageSource.camera : ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedimg = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final img = _selectedimg == null
        ? const AssetImage("assest/nodp.png")
        : FileImage(_selectedimg!);

    return getappbar(
        context,
        Padding(
            padding: EdgeInsets.all(50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pick a profile picture",
                    style: TextStyle(color: tcolor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Have a favourite selfie? Upload it now.",
                    style:
                        TextStyle(color: tcolor.withOpacity(0.5), fontSize: 9),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Stack(
                      clipBehavior: Clip.none,
                      // fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: img as ImageProvider,
                        ),
                        Positioned(
                          right: -16,
                          bottom: 0,
                          child: SizedBox(
                              height: 46,
                              width: 46,
                              child: GestureDetector(
                                onTap: () {
                                  showMenu(
                                      color: Colors.black,
                                      context: context,
                                      position: const RelativeRect.fromLTRB(
                                          40, 410, 30, 300),
                                      items: [
                                        PopupMenuItem(
                                          onTap: () {
                                            takepicture(true);
                                          },
                                          child: const Text(
                                            "Camera",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            takepicture(false);
                                          },
                                          child: const Text(
                                            "Gallery",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]);
                                },
                                child: Container(
                                  width: 10, // Set the desired width
                                  height: 10, // Set the desired height
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                    // Set the desired background color
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  // Add child widget here if needed
                                ),

                                // TODO: Icon not centered.
                              )),
                        )
                      ]),
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_selectedimg != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => username(
                                    widget.email,
                                    widget.userdetail,
                                    _selectedimg!,
                                    widget.password)));
                      } else {
                        return;
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 35,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: const Color.fromARGB(156, 224, 227, 229),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 15, 14, 14)
                                    .withOpacity(0.5),
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => username(
                                  widget.email,
                                  widget.userdetail,
                                  File("assest/nodp.jpg"),
                                  widget.password)));
                    },
                    child: Text(
                      "Skip for now",
                      style: TextStyle(
                          color: tcolor,
                          fontSize: 12,
                          decorationColor: tcolor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ])),
        false);
  }
}
