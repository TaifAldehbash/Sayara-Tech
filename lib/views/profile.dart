// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';
import 'package:sayaratech/components/bottombar.dart';
import 'package:dotted_border/dotted_border.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  late double deviceWidth, deviceHeight;
  late UserProfile profile = UserProfile(
      customerId: 0,
      name: "",
      engName: "",
      phone: "",
      email: "",
      username: "",
      walletBalance: 0,
      cashBackCoupon: Coupon(
          code: "",
          isActive: false,
          cashBackMoney: 0,
          desc: "",
          couponSharingMsg: ''),
      statistics: Statistics(
          noOfActiveCars: 0, noOfPaidRequests: 0, totalPaidInvoices: 0));

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: profile.customerId == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Teal background
                    Container(
                      width: deviceWidth,
                      height: deviceHeight * 0.2,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 125, 190, 178)),
                    ),
                    //Name
                    Container(
                      padding: EdgeInsets.only(
                          left: 0,
                          top: deviceHeight * 0.08,
                          right: 0,
                          bottom: deviceHeight * 0.03),
                      child: Text(
                        profile.engName,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 59, 65, 75)),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                          padding: EdgeInsets.only(top: deviceHeight * 0.01),
                          shrinkWrap: true,
                          children: [
                            //Form
                            Form(
                                child: Column(
                              children: [
                                //Email label
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 0,
                                      top: 0,
                                      right: deviceWidth * 0.75,
                                      bottom: 0),
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
                                      bottom: 10),
                                  child: TextFormField(
                                    initialValue: profile.email,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                // Phone number label
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 0,
                                      top: 0,
                                      right: deviceWidth * 0.6,
                                      bottom: 0),
                                  child: Text(
                                    "Phone number",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 59, 65, 75)),
                                  ),
                                ),
                                // Phone number textfield
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      top: 10,
                                      bottom: 10),
                                  child: TextFormField(
                                    initialValue: profile.phone,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                //Cash back coupon
                                Container(
                                  margin: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: deviceHeight * 0.01,
                                  ),
                                  child: DottedBorder(
                                    padding: EdgeInsets.only(
                                        left: deviceWidth * 0.01,
                                        right: deviceWidth * 0.01,
                                        top: deviceHeight * 0.02,
                                        bottom: deviceHeight * 0.02),
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(20),
                                    dashPattern: [10, 10],
                                    color: Colors.black26,
                                    strokeWidth: 2,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Cash back coupon",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 59, 65, 75)),
                                          ),
                                        ),
                                        //Cash back desc
                                        Visibility(
                                          visible:
                                              profile.cashBackCoupon.isActive,
                                          maintainSize: false,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: deviceWidth * 0.05,
                                                  right: deviceWidth * 0.05,
                                                  top: deviceHeight * 0.02,
                                                  bottom: deviceHeight * 0.03),
                                              child: Text(
                                                profile.cashBackCoupon.desc,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 59, 65, 75)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Cash back code
                                        Visibility(
                                          visible:
                                              profile.cashBackCoupon.isActive,
                                          maintainSize: false,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: deviceWidth * 0.06,
                                                  right: deviceWidth * 0.06,
                                                  top: 0,
                                                  bottom: 0),
                                              width: deviceWidth * 0.84,
                                              height: deviceHeight * 0.07,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Color.fromARGB(
                                                      255, 125, 190, 178)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    profile.cashBackCoupon.code,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        await Clipboard.setData(
                                                                ClipboardData(
                                                                    text: profile
                                                                        .cashBackCoupon
                                                                        .couponSharingMsg))
                                                            .then((_) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Copied Successfully")));
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.copy,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                        ),
                                        //Activate Cash back button
                                        Visibility(
                                          visible:
                                              !profile.cashBackCoupon.isActive,
                                          maintainSize: false,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print("Activate Coupon pressed");
                                              activateCoupon();
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0))),
                                                fixedSize: MaterialStateProperty.all(Size(
                                                    deviceWidth * 0.84,
                                                    deviceHeight * 0.07)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromARGB(
                                                            255, 125, 190, 178))),
                                            child: Text(
                                              "Activate Coupon",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Additional info
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      top: deviceHeight * 0.05,
                                      bottom: deviceHeight * 0.02),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.car_repair),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: deviceWidth * 0.57,
                                            left: deviceWidth * 0.01),
                                        child: Text(
                                          "My cars",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 59, 65, 75)),
                                        ),
                                      ),
                                      Text(
                                        profile.statistics.noOfActiveCars
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 59, 65, 75)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      top: deviceHeight * 0.03,
                                      bottom: deviceHeight * 0.02),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.wallet),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: deviceWidth * 0.31,
                                            left: deviceWidth * 0.01),
                                        child: Text(
                                          "Wallet Palance",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 59, 65, 75)),
                                        ),
                                      ),
                                      Text(
                                        profile.walletBalance
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 59, 65, 75)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      top: deviceHeight * 0.03,
                                      bottom: deviceHeight * 0.02),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.receipt),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: deviceWidth * 0.4,
                                            left: deviceWidth * 0.01),
                                        child: Text(
                                          "Paid Requests",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 59, 65, 75)),
                                        ),
                                      ),
                                      Text(
                                        profile.statistics.noOfPaidRequests
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 59, 65, 75)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      top: deviceHeight * 0.03,
                                      bottom: deviceHeight * 0.04),
                                  child: Row(
                                    children: [
                                      Icon(Icons.request_page),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: deviceWidth * 0.34,
                                            left: deviceWidth * 0.01),
                                        child: Text(
                                          "Paid Receipts",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 59, 65, 75)),
                                        ),
                                      ),
                                      Text(
                                        profile.statistics.totalPaidInvoices
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 59, 65, 75)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ]),
                    ),
                  ],
                ),
                //Profile avatar
                Positioned(
                  right: deviceWidth * 0.35,
                  top: deviceHeight * 0.1,
                  child: Container(
                    width: deviceWidth * 0.3,
                    height: deviceHeight * 0.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.white60, width: 5)),
                    child: Center(
                        child: Text(
                      profile.engName[0],
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    )),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomBar(activeItem: 2),
    );
  }

  Future<void> getProfile() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getFromApi("https://satc.live/api/Customer/Profile"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              profile = UserProfile.fromJson(response.getData());
            } else {
              print(response.message);
            }
          } else {
            print("response is null");
          }
        }));
  }

  Future<void> activateCoupon() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getFromApi("https://satc.live/api/Customer/RequestCashBackCoupon"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              profile.cashBackCoupon = Coupon.fromJson(response.data);
              print(response.getData());
            } else {
              print(response.message);
            }
          } else {
            print("response is null");
          }
        }));
  }
}
