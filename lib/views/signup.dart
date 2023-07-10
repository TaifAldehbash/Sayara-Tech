// ignore_for_file: prefer_const_constructors
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  late double deviceWidth, deviceHeight;
  String name = "";
  String email = "";
  String phoneNo = "";
  String errMsg = "";
  bool signupErr = false;
  bool invalidName = false;
  bool invalidEmail = false;
  bool invalidPhone = false;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
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
            //Sign in title
            Container(
              padding: EdgeInsets.only(
                  left: 0,
                  top: deviceHeight * 0.05,
                  right: 0,
                  bottom: deviceHeight * 0.05),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Name textfield label
            Container(
              padding: EdgeInsets.only(
                  left: 0, top: 0, right: deviceWidth * 0.75, bottom: 0),
              child: Text(
                "Name",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Name textfield
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06,
                  right: deviceWidth * 0.06,
                  top: 10,
                  bottom: deviceWidth * 0.06),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: "ie: user",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                autovalidateMode: invalidName
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    invalidName = true;
                    return "This field is required";
                  } else if (value.length <= 2) {
                    return "Name must be more than 2 characters";
                  } else if (signupErr) {
                    return errMsg;
                  } else {
                    invalidName = false;
                    name = value;
                  }
                  return null;
                },
              ),
            ),
            //Email textfield label
            Container(
              padding: EdgeInsets.only(
                  left: 0, top: 0, right: deviceWidth * 0.75, bottom: 0),
              child: Text(
                "Email",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Email textfield
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06,
                  right: deviceWidth * 0.06,
                  top: 10,
                  bottom: deviceWidth * 0.06),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "ie: user@mail.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                autovalidateMode: invalidEmail
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    invalidEmail = true;
                    return "This field is required";
                  } else if (!RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value)) {
                    return "Valid email is required";
                  } else {
                    invalidEmail = false;
                    email = value;
                  }
                  return null;
                },
              ),
            ),
            //Phone Number textfield label
            Container(
              padding: EdgeInsets.only(
                  left: 0, top: 0, right: deviceWidth * 0.6, bottom: 0),
              child: Text(
                "Phone number",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Phone Number textfield
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06,
                  right: deviceWidth * 0.06,
                  top: 10,
                  bottom: deviceWidth * 0.06),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "ie: 05xxxxxxxx",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                autovalidateMode: invalidPhone
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    invalidPhone = true;
                    return "This field is required";
                  } else if (!(RegExp(r'^(05)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
                      .hasMatch(value))) {
                    invalidPhone = true;
                    return "Valid phone number is required";
                  } else {
                    invalidPhone = false;
                    phoneNo = value.substring(1);
                  }
                  return null;
                },
              ),
            ),
            //Sign up button
            Container(
              padding: EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: deviceHeight * 0.05,
                  bottom: deviceHeight * 0.05),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    fixedSize: MaterialStateProperty.all(
                        Size(deviceWidth * 0.88, deviceHeight * 0.07)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 125, 190, 178))),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  print("Sign Up pressed");
                  if (!(invalidEmail && invalidName && invalidPhone)) {
                    signUp();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Sign up method to send user info as User obj to registerUser method in ApiServices to be posted to the API
  void signUp() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .registerUser(User(name: name, email: email, mobile: phoneNo)));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in RegisterAuth obj
              SignAuthentication authToken =
                  SignAuthentication.fromJson(response.getData());
              //Move to RegisterAuth page and send RegisterAuth (contains step 2 id, sms code) as argument
              authToken.mobileno = phoneNo;
              Navigator.of(context)
                  .pushNamed("/RegisterAuth", arguments: authToken);
            } else {
              //if request is not successful and response is flase show error msg
              signupErr = true;
              errMsg = response.message;
            }
          } else {
            //if request status code is not 200 and response returned null show error msg
            signupErr = true;
            errMsg = "Somthing went wrong, please try again later!";
          }
        }));
  }
}
