// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  late double deviceWidth, deviceHeight;
  String phoneNo = "";
  String errMsg = "";
  bool invalidPhone = false;
  bool signinErr = false;

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
                  top: deviceHeight * 0.07,
                  right: 0,
                  bottom: deviceHeight * 0.07),
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 59, 65, 75)),
              ),
            ),
            //Phone number textfield label
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
            //Phone number textfield
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06,
                  right: deviceWidth * 0.06,
                  top: 10,
                  bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "ie: 9665xxxxxxxx",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                autovalidateMode: invalidPhone
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    invalidPhone = true;
                    return "This field is required";
                  } else if (!(RegExp(r'^(9665)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
                      .hasMatch(value))) {
                    invalidPhone = true;
                    return "Valid phone number is required";
                  } else if (signinErr) {
                    return errMsg;
                  } else {
                    invalidPhone = false;
                    phoneNo = value;
                  }
                  return null;
                },
              ),
            ),
            //Sign in button
            Container(
              padding: EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: deviceHeight * 0.05,
                  bottom: deviceHeight * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  print("Sign in pressed");
                  if (!invalidPhone) signin();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    fixedSize: MaterialStateProperty.all(
                        Size(deviceWidth * 0.84, deviceHeight * 0.07)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 125, 190, 178))),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //Sign up row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 59, 65, 75)),
                ),
                //Sign up page button
                TextButton(
                    onPressed: () {
                      print("Sign up pressed");
                      Navigator.of(context).pushNamed("/SignUp");
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

//Sign in method to send mobile number as SignInUser obj to signinUser method in ApiServices to be posted to the API
  void signin() async {
    //Define SignInUser obj with user mobile number
    SignAuthentication signUser = SignAuthentication.mobileNo(phoneNo);
    //Response obj to store the returned response from signinUser method in ApiServices
    Response? response = (await ApiServices().signinUser(signUser));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in signUser obj
              signUser = SignAuthentication.fromJson(response.getData());
              signUser.mobileno = phoneNo;
              //Move to SigninAuth page and send signUser (contains mobile no, step 2 id, sms code) as argument
              Navigator.of(context)
                  .pushNamed("/SigninAuth", arguments: signUser);
            } else {
              //if request is not successful and response is flase show error msg
              signinErr = true;
              errMsg = response.message;
            }
          } else {
            //if request status code is not 200 and response returned null show error msg
            signinErr = true;
            errMsg = "Somthing went wrong, please try again later!";
          }
        }));
  }
}
