import 'package:flutter/material.dart';

class notificationpage extends StatefulWidget {
  const notificationpage({super.key});

  @override
  State<notificationpage> createState() => _notificationpageState();
}

class _notificationpageState extends State<notificationpage> {
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
            const SizedBox(width: 110),
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
