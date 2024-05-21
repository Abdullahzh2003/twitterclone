import 'package:flutter/material.dart';

class drawersub extends StatefulWidget {
  const drawersub({super.key});

  @override
  State<drawersub> createState() => _drawersubState();
}

class _drawersubState extends State<drawersub> {
  bool settingopen = false;
  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      children: [
        ListTile(
            onTap: () {
              setState(() {
                settingopen = !settingopen;
              });
            },
            title: Text(
              "Settings and support",
              style: TextStyle(color: tcolor, fontSize: 11),
            ),
            trailing: settingopen
                ? const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  )),
        if (settingopen)
          Container(
            height: MediaQuery.of(context).size.height *
                0.2, // Adjust the height as needed
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -3),
                    onTap: () {
                      // Handle the tap event
                    },
                    leading: Icon(
                      Icons.settings,
                      color: tcolor,
                    ),
                    title: Text(
                      "Settings and Privacy",
                      style: TextStyle(color: tcolor, fontSize: 11),
                    ),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -3),
                    onTap: () {
                      // Handle the tap event
                    },
                    leading: Icon(
                      Icons.help_center_outlined,
                      color: tcolor,
                    ),
                    title: Text(
                      "Help Center",
                      style: TextStyle(color: tcolor, fontSize: 11),
                    ),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -3),
                    onTap: () {
                      // Handle the tap event
                    },
                    leading: Icon(
                      Icons.shopping_cart,
                      color: tcolor,
                    ),
                    title: Text(
                      "Purchases",
                      style: TextStyle(color: tcolor, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
