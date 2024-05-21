import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitterclone/blueprint/user.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:twitterclone/screen/passwordset.dart';

class newuser extends StatefulWidget {
  const newuser({super.key});

  @override
  State<newuser> createState() => _newuserState();
}

class _newuserState extends State<newuser> {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  late user userdetail;
  Widget? namevalidate;
  Widget? emailvalidate;
  Widget? datevalidate;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    datecontroller.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
  }

  void submitdata() {
    bool flag = true;

    if (namecontroller.text.toString().trim().isEmpty ||
        namecontroller.text.length < 4) {
      namevalidate = const Icon(
        Icons.error_rounded,
        color: Colors.red,
      );
      setState(() {});
      flag = false;
    }
    if (flag) {
      namevalidate = const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.green,
      );
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (emailcontroller.text.toString().trim().isEmpty ||
        !emailRegExp.hasMatch(emailcontroller.text.trim())) {
      emailvalidate = const Icon(
        Icons.error_rounded,
        color: Colors.red,
      );
      setState(() {});
      flag = false;
    }
    if (flag) {
      emailvalidate = const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.green,
      );
    }
    if (datecontroller.text.toString().trim().isEmpty) {
      datevalidate = const Icon(
        Icons.error_rounded,
        color: Colors.red,
      );
      setState(() {});
      flag = false;
    }
    if (flag) {
      userdetail = user(name: namecontroller.text, dob: datecontroller.text);
      datevalidate = const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.green,
      );
      Future.delayed(Duration(milliseconds: 1000))
          .then((value) => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Passwordset(
                    userdetail,
                    emailcontroller.text,
                  );
                },
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return getappbar(
        context,
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your account",
                style: TextStyle(
                    color: tcolor, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextField(
                  controller: namecontroller,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: tcolor), // Change the color of the bottom line
                    ),
                    suffixIcon: namevalidate ?? namevalidate,
                    //  const Icon(
                    //   Icons.check_circle,
                    //   color: Colors.green,
                    // ),
                    label: Text(
                      "Name",
                      style: TextStyle(
                          color: tcolor.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              TextField(
                  controller: emailcontroller,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: tcolor), // Change the color of the bottom line
                    ),
                    suffixIcon: emailvalidate ?? emailvalidate,
                    label: Text(
                      "Email",
                      style: TextStyle(
                          color: tcolor.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              GestureDetector(
                  onTap: () async {
                    DateTime? picked1 = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2020),
                        initialDate: DateTime(2010));
                    datecontroller.text =
                        DateFormat('d MMMM, yyyy').format(picked1!);
                    setState(() {});
                  },
                  child: AbsorbPointer(
                    child: TextField(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 12),
                        controller: datecontroller,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    tcolor), // Change the color of the bottom line
                          ),
                          suffixIcon: datevalidate ?? datevalidate,
                          label: Text(
                            "Date of birth",
                            style: TextStyle(
                                color: tcolor.withOpacity(0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  )),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: submitdata,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                    )),
              )
            ],
          ),
        ),
        true);
  }
}
