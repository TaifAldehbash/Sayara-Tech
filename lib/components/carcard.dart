// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';

class CarCard extends StatefulWidget {
  late Car car;
  late Uint8List bytesImage;
  CarCard(this.car) {
    bytesImage = Base64Decoder().convert(car.vendorsBinaryImage);
  }

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late double deviceWidth, deviceHeight;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.27,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Car vendor logo
          Container(
            padding: EdgeInsets.only(
                bottom: deviceHeight * 0.17, left: deviceWidth * 0.02),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.memory(
              widget.bytesImage,
              width: deviceWidth * 0.25,
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.car.modelsEngName,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 59, 65, 75),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                widget.car.vendorEgnName,
                style: TextStyle(
                    fontSize: 15.0, color: Color.fromARGB(255, 59, 65, 75)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  SvgPicture.asset(
                    "assets/plate.svg",
                    width: deviceWidth * 0.05,
                    height: deviceHeight * 0.05,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.01,
                            left: deviceWidth * 0.025),
                        child: Text(widget.car.carLicNo.substring(0, 4),
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 59, 65, 75))),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.01, left: deviceWidth * 0.11),
                        child: Text(widget.car.carLicNo.substring(4),
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 59, 65, 75))),
                      ),
                    ],
                  ),
                ],
              ),
              // Update button
              Container(
                padding: EdgeInsets.only(
                  left: deviceWidth * 0.22,
                  right: 0,
                  top: deviceHeight * 0.03,
                  // bottom: deviceHeight * 0.01
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      )),
                      fixedSize: MaterialStateProperty.all(
                        Size(deviceWidth * 0.3, deviceHeight * 0.05),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 125, 190, 178))),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    print("update pressed");
                    getCar();
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Future<void> getCar() async {
    int id = widget.car.id;
    //Response obj to store the returned response from method in ApiServices
    Response? response = (await ApiServices()
        .getFromApi("https://satc.live/api/Customer/Car/$id"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              Navigator.of(context).pushNamed("/CarInfo",
                  arguments: Car.fromJson2(response.data));
              print(response.data);
            } else {
              print(response.message);
            }
          } else {
            print("response is null");
          }
        }));
  }
}
