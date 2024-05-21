import 'package:flutter/material.dart';
import 'package:twitterclone/blueprint/user.dart';
import 'package:twitterclone/fetchdata/data.dart';

import 'package:twitterclone/screen/profile.dart';

class Passwordset extends StatefulWidget {
  const Passwordset(this.userdetail, this.email, {super.key});
  final user userdetail;
  final String email;

  @override
  State<Passwordset> createState() => _passwordsetState();
}

class _passwordsetState extends State<Passwordset> {
  TextEditingController passcontroller = TextEditingController();
  bool hidepass = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passcontroller.dispose();
  }

  final _formkey = GlobalKey<FormState>();
  // Future<void> onsaved(File img, String username) async {
  //   Random random = Random();

  //   // Generate a random number between 100 and 999 (inclusive)
  //   int randomNumber = random.nextInt(900) + 100;
  //   try {
  //     // print("fjhndjfsdkkkkkkkkkkkkkkkkkkkkkkk");
  //     final UserCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: widget.email, password: passcontroller.text);

  //     final Storageref = FirebaseStorage.instance
  //         .ref()
  //         .child('user_imges')
  //         .child('${UserCredential.user!.uid}.jpg');
  //     await Storageref.putFile(img);
  //     final imgurl = await Storageref.getDownloadURL();
  //     widget.userdetail.imgurl = imgurl;
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(UserCredential.user!.uid)
  //         .set({
  //       'name': widget.userdetail.name,
  //       'dob': widget.userdetail.dob!,
  //       'username': username == ""
  //           ? "${widget.userdetail.name!.substring(0, 3)}$randomNumber"
  //           : username,
  //       'email': widget.email,
  //       'image_url': widget.userdetail.imgurl,
  //       'likepost': [],
  //       'bio': widget.userdetail.bio,
  //       'followlist': [],
  //       'followinglist': [],
  //       'postlist': []
  //     });
  //     // Navigator.pushAndRemoveUntil(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => Homepage()),
  //     //   (route) => false, // This function ensures that all routes are removed
  //     // );
  //   } on FirebaseAuthException catch (error) {
  //     showDialog(
  //         context: context,
  //         builder: (ctx) {
  //           return AlertDialog(
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(ctx);
  //                   },
  //                   child: const Text(
  //                     'Okay',
  //                     style: TextStyle(color: Colors.black, fontSize: 10),
  //                   ))
  //             ],
  //             content: Text(
  //               error.code,
  //               style: TextStyle(fontSize: 12, color: Colors.black),
  //             ),
  //           );
  //         });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return getappbar(
        context,
        Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You'll need a password",
                    style: TextStyle(color: tcolor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Make sure it's 8 characters or more.",
                    style:
                        TextStyle(color: tcolor.withOpacity(0.5), fontSize: 9),
                  ),
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                      controller: passcontroller,
                      obscureText: hidepass ? true : false,
                      validator: (value) {
                        if (passcontroller.text.length < 8) {
                          return "Your password need to be at least 8 characters. Please enter a longer one";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    tcolor), // Change the color of the bottom line
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                hidepass = !hidepass;
                              });
                            },
                            child: Icon(
                              hidepass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_rounded,
                              color: tcolor.withOpacity(0.3),
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontSize: 10.0, color: tcolor.withOpacity(0.4))),
                    ),
                  ),
                  if (passcontroller.text.length < 8 &&
                      passcontroller.text.isNotEmpty)
                    Column(
                      children: [
                        ClipPath(
                          clipper: MessageClipper(),
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            color: const Color.fromARGB(255, 244, 3, 3),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 244, 3, 3),
                              borderRadius: BorderRadius.horizontal()),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Password must be of 8 Characters or more,Type again in correct format",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20.0, color: tcolor),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'By signing up, you agree to our  ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: tcolor.withOpacity(0.6))),
                        const TextSpan(
                          text: 'Terms, Privacy Policy',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 137,
                                  238), // Set the color for this part
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        TextSpan(
                            text: ' and ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: tcolor.withOpacity(0.6))),
                        const TextSpan(
                          text: 'Cookie Use',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 137,
                                  238), // Set the color for this part
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        TextSpan(
                            text:
                                'X may use your contact information, including your email address and phone number for purposes outlined in our Privacy Policy. Learn more',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: tcolor.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        // _formkey.currentState!.save();
                        // final userid = await fireauth.FirebaseAuth.instance
                        //     .createUserWithEmailAndPassword(
                        //         email: widget.email, password: passcontroller.text);
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return Profile1(widget.userdetail, widget.email,
                              passcontroller.text);
                        })));
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
                            "Sign up",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 15, 14, 14)
                                    .withOpacity(0.5),
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        true);
  }
}
