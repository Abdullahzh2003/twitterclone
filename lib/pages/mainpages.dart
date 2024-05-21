import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/widget.dart/openinput.dart';

import 'package:twitterclone/widget.dart/postlist.dart';

class mainpage extends StatefulWidget {
  const mainpage({super.key});

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  bool? flag = true;
  String? swipeDirection;
  @override
  Widget build(BuildContext context) {
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Image.asset(getlogoimg(context)))],
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
          },
          onPanEnd: (details) {
            if (swipeDirection == null) {
              return;
            }
            if (swipeDirection == 'left') {
              //handle swipe left event
              setState(() {
                flag = false;
                // widget.homechange(widget.flag3);
              });
            }
            if (swipeDirection == 'right') {
              //handle swipe right event
              setState(() {
                flag = true;
                // widget.homechange(widget.flag3);
              });
            }
          },
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        shadowColor: MaterialStateColor.resolveWith((states) {
                          return bcolor;
                        }),
                        backgroundColor:
                            MaterialStateColor.resolveWith((states) {
                          return bcolor;
                        }),
                      ),
                      onPressed: () {
                        print("jfsdhfhgdsgffhsg");
                        setState(() {
                          flag = true;
                        });
                      },
                      child: Text(
                        'For you',
                        style: TextStyle(color: tcolor, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateColor.resolveWith((states) {
                          return bcolor;
                        }),
                      ),
                      onPressed: () {
                        print("jfsdhfhgdsgffhsg");

                        setState(() {
                          flag = false;
                          // widget.homechange(widget.flag3);
                        });
                      },
                      child: Text(
                        'Following',
                        style: TextStyle(color: tcolor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: flag!
                            ? MediaQuery.of(context).size.width * 0.23
                            : MediaQuery.of(context).size.width * 0.65),
                    Container(
                      width: 40,
                      height: 1.5,
                      color: Colors.blue,
                    ),
                  ],
                ),
                if (flag!) const postlistscreen(),
                if (!flag!)
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 155,
                  )
              ],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                height: 90,
                width: 90,
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: bcolor,
                          context: context,
                          builder: (context) {
                            return openinputscreen();
                          });
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 50,
                    ))),
          ]),
        )
      ],
    );
  }
}
