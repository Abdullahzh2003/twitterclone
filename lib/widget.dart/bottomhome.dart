import 'package:flutter/material.dart';

class bottomhome extends StatefulWidget {
  const bottomhome(this.applychange, {super.key});
  final void Function(String) applychange;
  @override
  State<bottomhome> createState() => _BottomhomeState();
}

class _BottomhomeState extends State<bottomhome> {
  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    return BottomAppBar(
      color: bcolor.withOpacity(0.7),
      child: SizedBox(
        width: 30,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () {
                widget.applychange("home");
              },
              icon: Icon(
                Icons.home,
                color: tcolor,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                widget.applychange("search");
              },
              icon: Icon(
                Icons.search,
                color: tcolor,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                widget.applychange("notification");
              },
              icon: Icon(
                Icons.notifications,
                size: 25,
                color: tcolor,
              )),
          IconButton(
              onPressed: () {
                widget.applychange("message");
              },
              icon: Icon(
                Icons.message_sharp,
                size: 25,
                color: tcolor,
              ))
        ]),
      ),
    );
  }
}
