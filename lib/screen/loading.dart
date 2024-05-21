import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/data.dart';

class loading extends StatelessWidget {
  const loading({super.key});

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return getappbar(
        context,
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Loading ..."),
                const SizedBox(
                  height: 30,
                ),
                CircularProgressIndicator(
                  color: tcolor,
                )
              ],
            ),
          ),
        ),
        true);
  }
}
