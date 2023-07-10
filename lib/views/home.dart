// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';
import 'package:sayaratech/components/bottombar.dart';
import 'package:sayaratech/components/carcard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late double deviceWidth, deviceHeight;
  List<Car> cars = [];
  @override
  void initState() {
    super.initState();
    getCars();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Logo
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.07,
                    bottom: deviceHeight * 0.02,
                    left: deviceWidth * 0.3),
                child: SvgPicture.asset(
                  "assets/logo.svg",
                  width: deviceWidth * 0.05,
                  height: deviceHeight * 0.05,
                ),
              ),
              //Back button to home page
              Container(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.04, left: deviceWidth * 0.2),
                child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  onPressed: () {
                    ApiServices().setToken("").then((value) =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/SignIn", ModalRoute.withName('/')));
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: cars.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You don't have any cars yet.",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 59, 65, 75)),
                        ),
                        //Sign up page button
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/NewCar");
                            },
                            child: Text(
                              "Add a new car",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: deviceHeight * 0.01),
                    shrinkWrap: true,
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: 0,
                            bottom: deviceHeight * 0.03),
                        child: CarCard(cars[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        activeItem: 0,
      ),
    );
  }

  Future<void> getCars() async {
    //Response obj to store the returned response from method in ApiServices
    Response? response =
        (await ApiServices().getFromApi("https://satc.live/api/Customer/Cars"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list

              for (var element in response.getData()) {
                cars.add(Car.fromJson2(element));
              }
            } else {
              print(response.message);
            }
          } else {
            print("response is null");
          }
        }));
  }
}
