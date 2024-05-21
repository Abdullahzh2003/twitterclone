import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/fetchdata/fetchdynamic.dart';

class searchscreen extends StatefulWidget {
  const searchscreen({super.key});

  @override
  State<searchscreen> createState() => _searchscreenState();
}

class _searchscreenState extends State<searchscreen> {
  TextEditingController searchcontroller = TextEditingController();
  List<DocumentSnapshot> documentsList = [];

  Future<void> fetchUsersWithName(String searchText) async {
    if (searchcontroller.text != "") {
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await usersRef
          .where('name',
              isGreaterThanOrEqualTo: searchText,
              isLessThanOrEqualTo: searchText + '\uf8ff')
          .get();

      documentsList = querySnapshot.docs.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    MaterialStateProperty<TextStyle> getstyle() {
      return MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyle(color: tcolor.withOpacity(0.3));
        }
        return TextStyle(color: tcolor.withOpacity(0.3));
      });
    }

    return Scaffold(
        backgroundColor: bcolor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28.0, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 250,
                      height: 35,
                      child: SearchBar(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: searchcontroller,
                        leading: Icon(
                          Icons.search,
                          color: tcolor.withOpacity(0.3),
                        ),
                        hintText: "search",
                        textStyle: getstyle(),
                        hintStyle: getstyle(),
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color.fromARGB(255, 64, 64,
                                64); // Color when the widget is disabled
                          }
                          return const Color.fromARGB(
                              255, 80, 79, 79); // Default color
                        }),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: tcolor.withOpacity(0.6), fontSize: 12),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (documentsList != [])
              FutureBuilder(
                  future: fetchUsersWithName(searchcontroller.text == 'null'
                      ? "112233"
                      : searchcontroller.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                          height: 350,
                          child: ListView.builder(
                              itemCount: documentsList.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot post = documentsList[index];

                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      profilecircleuser(25, post.id),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['name'],
                                            style: TextStyle(
                                              color: tcolor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            post['username'],
                                            style: TextStyle(
                                              color: tcolor.withOpacity(0.4),
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }));
                    }
                  })
          ],
        ));
  }
}
