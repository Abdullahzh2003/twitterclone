import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/screen/loginuser.dart';
import 'package:twitterclone/screen/newuser.dart';

class startingscreen extends StatefulWidget {
  const startingscreen({super.key});

  @override
  State<startingscreen> createState() => _startingscreenState();
}

class _startingscreenState extends State<startingscreen> {
  @override
  Widget build(BuildContext context) {
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Have an account already?",
              style: TextStyle(color: tcolor.withOpacity(0.3), fontSize: 8),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loginuser()));
              },
              child: Text(
                " Login",
                style: TextStyle(
                    color: Colors.blue.withOpacity(0.99), fontSize: 8),
              ),
            )
          ],
        ),
      ),
      backgroundColor: bcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bcolor,
        title: Center(child: Image.asset(getlogoimg(context))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "See Whats happening in the world right now. ",
              style: TextStyle(color: tcolor, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => newuser(),
                    ));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: 35,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Color.fromARGB(194, 77, 175, 232),
                  child: Center(
                    child: Text(
                      "Create account",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.99), fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
