// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sayaratech/api+models/models.dart';
import 'package:sayaratech/api+models/apiservices.dart';

class SignInAuth extends StatefulWidget {
  const SignInAuth({super.key});
  @override
  State<SignInAuth> createState() => _SignInAuth();
}

class _SignInAuth extends State<SignInAuth> {
  late double deviceWidth, deviceHeight;
  late SignAuthentication args;
  bool authErr = false;
  String pin = "";
  String pin1 = "";
  String pin2 = "";
  String pin3 = "";
  String pin4 = "";

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    //Extract recieved arguments as SignInUser
    args = ModalRoute.of(context)!.settings.arguments as SignAuthentication;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onVerticalDragEnd: (DragEndDetails details) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Back button to sign in page
            Container(
              padding: EdgeInsets.only(right: deviceWidth * 0.8),
              child: BackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            //Logo
            SvgPicture.asset(
              "assets/logo.svg",
              width: deviceWidth * 0.09,
              height: deviceHeight * 0.09,
            ),
            //Verification page title
            Container(
              padding: EdgeInsets.only(
                  left: 0,
                  top: deviceHeight * 0.07,
                  right: 0,
                  bottom: deviceHeight * 0.03),
              child: Text(
                "Verification Code",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //msg text
            Container(
              padding: EdgeInsets.only(
                  left: 0, top: 0, right: 0, bottom: deviceHeight * 0.07),
              child: Text(
                "We have sent a verfication code to you",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Form container
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06,
                  right: deviceWidth * 0.06,
                  bottom: deviceHeight * 0.01),
              //Code form
              child: Form(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //First pin number field
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (pin1) {
                        if (pin1.length == 1) {
                          FocusScope.of(context).nextFocus();
                          this.pin1 = pin1;
                        }
                      },
                    ),
                  ),
                  //Second pin number field
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (pin2) {
                        if (pin2.length == 1) {
                          FocusScope.of(context).nextFocus();
                          this.pin2 = pin2;
                        }
                      },
                    ),
                  ),
                  //Third pin number field
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (pin3) {
                        if (pin3.length == 1) {
                          FocusScope.of(context).nextFocus();
                          this.pin3 = pin3;
                        }
                      },
                    ),
                  ),
                  //Fourth pin number field
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (pin4) {
                        if (pin4.length == 1) {
                          this.pin4 = pin4;
                          print(pin1 + pin2 + pin3 + pin4);
                        }
                      },
                    ),
                  ),
                ],
              )),
            ),
            //Error msg shows when authErr boolean is true
            Visibility(
              visible: authErr,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                padding: EdgeInsets.only(
                    left: 0, top: 0, right: 0, bottom: deviceHeight * 0.06),
                child: Text(
                  "Invalid SMS Verification Code",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[900]),
                ),
              ),
            ),
            //Resend and confirm buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Resend button
                Container(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: deviceHeight * 0.05,
                      bottom: deviceHeight * 0.18),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        width: 2.5,
                                        color: Color.fromARGB(
                                            255, 125, 190, 178)))),
                        fixedSize: MaterialStateProperty.all(
                          Size(deviceWidth * 0.44, deviceHeight * 0.07),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 125, 190, 178),
                      ),
                    ),
                    onPressed: () {
                      print("Resend pressed");
                      resendAuth();
                    },
                  ),
                ),
                //Confirm button
                Container(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: deviceHeight * 0.05,
                      bottom: deviceHeight * 0.18),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                        fixedSize: MaterialStateProperty.all(
                            Size(deviceWidth * 0.44, deviceHeight * 0.07)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 125, 190, 178))),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      pin = pin1 + pin2 + pin3 + pin4;
                      print("Confirm pressed");
                      args.smscode = pin;

                      authenticate();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void authenticate() async {
    bool response = (await ApiServices().signinAuth(args));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response) {
            //RegisterAuth authToken = RegisterAuth.fromJson(response.getData());
            Navigator.of(context).pushNamed("/Home");
          } else {
            authErr = true;
            print("null");
          }
        }));
  }

  void resendAuth() async {
    SignAuthentication signUser;
    Response? response = (await ApiServices().signinUser(args));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response!.status) {
            signUser = SignAuthentication.fromJson(response.getData());
            print(signUser.smscode);
            args.smscode = signUser.smscode;
            args.idStep2 = signUser.idStep2;
          } else {
            print("null");
          }
        }));
  }
}
