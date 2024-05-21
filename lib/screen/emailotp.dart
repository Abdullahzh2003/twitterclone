import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:twitterclone/blueprint/user.dart';
import 'package:twitterclone/fetchdata/data.dart';
import 'package:otp_text_field/otp_field.dart';

import 'package:otp_text_field/style.dart';
import 'package:twitterclone/screen/passwordset.dart';
// import 'package:pinput/pinput.dart';

class Emailotp extends StatefulWidget {
  const Emailotp(this.userdetail, this.email, {super.key});

  final String email;
  final user userdetail;

  @override
  State<Emailotp> createState() => _emailotpState();
}

class _emailotpState extends State<Emailotp> {
  EmailOTP myAuth = EmailOTP();
  bool isverify = false;
  bool flag = true;
  var otp;
  void sendotp() async {
    myAuth.setConfig(
        appEmail: "abdullahzh2003@gmail.com",
        appName: "Twitter Clone",
        userEmail: widget.email,
        otpLength: 5,
        otpType: OTPType.digitsOnly);

    await myAuth.sendOTP();
  }

  @override
  void initState() {
    super.initState;
    sendotp();
  }

  void verifyotp() async {
    setState(() {
      isverify = true;
    });

    flag = await myAuth.verifyOTP(otp: otp);

    if (flag) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) =>
                  Passwordset(widget.userdetail, widget.email))));
    } else {
      setState(() {
        isverify = false;
      });
      Future.delayed(const Duration(milliseconds: 2500)).then((value) {
        setState(() {
          flag = !flag;
        });
      });
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
                  "We sent you a code",
                  style: TextStyle(color: tcolor, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter it below to verify ${widget.email}.",
                  style: TextStyle(color: tcolor.withOpacity(0.5), fontSize: 8),
                ),
                const SizedBox(
                  height: 16,
                ),
                OTPTextField(
                  length: 5,
                  otpFieldStyle: OtpFieldStyle(
                    enabledBorderColor: tcolor,
                    focusBorderColor: tcolor,
                  ),
                  keyboardType: TextInputType.number,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 30,
                  style: TextStyle(fontSize: 17, color: tcolor),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    otp = pin;
                  },
                ),
                if (!flag)
                  Column(
                    children: [
                      ClipPath(
                        clipper: MessageClipper(),
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromARGB(255, 221, 64, 61),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 221, 64, 61),
                            borderRadius: BorderRadius.horizontal()),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Code that you entered is incorrect. Please try again",
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: sendotp,
                  child: Text(
                    "Didn't receive email?",
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 110, 180, 238).withOpacity(0.6),
                        fontSize: 8),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: verifyotp,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 35,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Color.fromARGB(156, 224, 227, 229),
                      child: Center(
                        child: isverify
                            ? const CircularProgressIndicator()
                            : Text(
                                "Next",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 15, 14, 14)
                                        .withOpacity(0.5),
                                    fontSize: 11),
                              ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                )
              ],
            )),
        true);
  }
}
