import 'package:flutter/material.dart';

class messagepage extends StatefulWidget {
  const messagepage({super.key});

  @override
  State<messagepage> createState() => _messagepageState();
}

class _messagepageState extends State<messagepage> {
  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 140),
            Text(
              "Notification",
              style: TextStyle(color: tcolor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
