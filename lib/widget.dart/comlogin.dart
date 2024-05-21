import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/screen/homepage.dart';

class comlogin extends StatefulWidget {
  const comlogin(this.email, {super.key});
  final String email;

  @override
  State<comlogin> createState() => _comloginState();
}

class _comloginState extends State<comlogin> {
  TextEditingController passcontroller = TextEditingController();
  bool hidepass = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your password",
              style: TextStyle(
                color: tcolor,
                fontSize: 18,
              ),
            ),
            TextField(
              style: TextStyle(color: tcolor),
              // controller: emailcontroller,
              readOnly: true,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: tcolor), // Change the color of the bottom line
                ),
                label: Text(
                  widget.email,
                  style:
                      TextStyle(color: tcolor.withOpacity(0.7), fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passcontroller,
              obscureText: hidepass ? true : false,
              style: TextStyle(color: tcolor),
              decoration: InputDecoration(
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
                label: Text(
                  "Password",
                  style:
                      TextStyle(color: tcolor.withOpacity(0.7), fontSize: 12),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () async {
                  try {
                    // Send password reset email
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: widget.email);
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text(
                                    'Okay',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ))
                            ],
                            content: Text(
                              "Email reset link is send to ${widget.email}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          );
                        });
                    // Show a success message or navigate to a screen informing the user to check their email
                  } catch (e) {
                    // Handle any errors, such as invalid email or user not found
                    print("Error sending password reset email: $e");
                  }
                },
                child: Text(
                  "Forget Password?",
                  style: TextStyle(color: tcolor, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: widget.email, password: passcontroller.text);
                  print(userCredential);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                    (route) =>
                        false, // This function ensures that all routes are removed
                  );
                } on FirebaseAuthException catch (error) {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text(
                                  'Okay',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ))
                          ],
                          content: Text(
                            error.code,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        );
                      });
                  ;
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
                      "Log in",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 15, 14, 14)
                              .withOpacity(0.5),
                          fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
