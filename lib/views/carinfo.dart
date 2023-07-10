// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sayaratech/api+models/apiservices.dart';
import 'package:sayaratech/api+models/models.dart';
import 'package:sayaratech/components/bottombar.dart';

class CarInfo extends StatefulWidget {
  CarInfo({super.key});

  @override
  State<CarInfo> createState() => _CarInfo();
}

class _CarInfo extends State<CarInfo> {
  late double deviceWidth, deviceHeight;
  late Car car;
  Vendor vendor = Vendor(id: -1, engName: "");
  Model model = Model(id: -1, engName: "", carVendorId: -1);
  int fuel = -1;
  int colorId = -1;
  int cylinder = -1;
  int year = 0;
  String vin = "";
  String plateNo = "";
  bool err = false;
  bool showModel = false;
  bool showCylinder = false;
  List<DropdownMenuItem<Vendor>> vendors = [];
  List<DropdownMenuItem<Model>> models = [];
  List<DropdownMenuItem<Model>> filterModels = [];
  List<DropdownMenuItem<int>> cylinders = [];
  List<DropdownMenuItem<int>> fuelTypes = [];
  List<DropdownMenuItem<int>> colors = [];
  List<DropdownMenuItem<int>> years = [];

  @override
  void initState() {
    super.initState();
    getVendorItems();
    getModelItems();
    getFuelItems();
    getColorItems();
    getYears();
  }

  @override
  Widget build(BuildContext context) {
    car = ModalRoute.of(context)!.settings.arguments as Car;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    if (cylinders.isEmpty) getCylinder();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onVerticalDragEnd: (DragEndDetails details) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Back button to home page
                Container(
                  padding: EdgeInsets.only(
                      top: deviceHeight * 0.04, right: deviceWidth * 0.2),
                  child: BackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                //Logo
                Padding(
                  padding: EdgeInsets.only(
                      top: deviceHeight * 0.07,
                      bottom: deviceHeight * 0.02,
                      right: deviceWidth * 0.3),
                  child: SvgPicture.asset(
                    "assets/logo.svg",
                    width: deviceWidth * 0.05,
                    height: deviceHeight * 0.05,
                  ),
                ),
              ],
            ),
            (vendors.isEmpty ||
                    models.isEmpty ||
                    cylinders.isEmpty ||
                    fuelTypes.isEmpty ||
                    colors.isEmpty)
                ? Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.35, bottom: deviceHeight * 0.45),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView(
                        padding: EdgeInsets.only(top: deviceHeight * 0.01),
                        shrinkWrap: true,
                        children: [
                          //Form
                          Form(
                              child: Column(
                            children: [
                              //Vendor label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.62,
                                    bottom: 0),
                                child: Text(
                                  "Type of car",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Vendor list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: vendors
                                      .firstWhere((element) =>
                                          element.value!.id == car.carVendorId)
                                      .value,
                                  hint: Text('Choose a type of car*'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: vendors,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = value!;
                                      model = Model(
                                          id: -1, engName: "", carVendorId: -1);
                                      filterModels = filterM();
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (vendor.id == -1) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Model label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.7,
                                    bottom: 0),
                                child: Text(
                                  "Model",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Model list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: vendor.id == -1
                                      ? models
                                          .firstWhere((element) =>
                                              element.value!.id ==
                                              car.carModelId)
                                          .value
                                      : null,
                                  hint: Text('Choose a model*'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: filterModels = filterM(),
                                  onChanged: (value) {
                                    setState(() {
                                      model = value!;
                                      cylinder = -1;
                                      getCylinder();
                                    });
                                  },
                                  autovalidateMode: err
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (model.id == -1 && err) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Cylinder count
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.55,
                                    bottom: 0),
                                child: Text(
                                  "Cylinder count",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Cylinder count list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: model.id != -1 ? null : car.cylinderId,
                                  hint: Text('Choose a cylinder count*'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: cylinders,
                                  onChanged: (value) {
                                    setState(() {
                                      cylinder = value!;
                                    });
                                  },
                                  autovalidateMode: err
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (cylinder == -1 &&
                                        (model.id != -1 || vendor.id != -1) &&
                                        err) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Fuel label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.74,
                                    bottom: 0),
                                child: Text(
                                  "Fuel",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Fuel list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: car.carFuleTypeId,
                                  hint: Text('Choose a fuel type*'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: fuelTypes,
                                  onChanged: (value) {
                                    setState(() {
                                      fuel = value!;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (fuel == -1) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Car registration info
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.28,
                                    bottom: 10),
                                child: Text(
                                  "Car registration information",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //VIN label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.28,
                                    bottom: 0),
                                child: Text(
                                  "Vehicle Identification Number",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //VIN textfield
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: TextFormField(
                                  initialValue: car.boardNo,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "ie: xxxxxxxxxxxxxxxxx",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (!RegExp(
                                            r"^(?=.*[0-9])(?=.*[A-z])[0-9A-z-]{17}$")
                                        .hasMatch(value!)) {
                                      return "Valid VIN contains 17 letters and digits";
                                    } else {
                                      // setState(() {
                                      vin = value;
                                      // });
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              //License plate number label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.43,
                                    bottom: 0),
                                child: Text(
                                  "License plate number",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //License plate number textfield
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: TextFormField(
                                  initialValue: car.carLicNo,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "ie: 1234abcd",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (!RegExp(r"^\d{4}[aA-zZ]{4}$")
                                        .hasMatch(value!)) {
                                      return "Valid license plate caontains 4 digits and 4 letters";
                                    } else {
                                      // set/State(() {
                                      plateNo = value;
                                      // });
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              //Additional information
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.4,
                                    bottom: 10),
                                child: Text(
                                  "Additional information",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Color label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.7,
                                    bottom: 0),
                                child: Text(
                                  "Color",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Color list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: car.carColorId,
                                  hint: Text('Choose a color'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: colors,
                                  onChanged: (value) {
                                    setState(() {
                                      colorId = value!;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (colorId == -1) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Manufacture year label
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: deviceWidth * 0.48,
                                    bottom: 0),
                                child: Text(
                                  "Manufacture year",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 59, 65, 75)),
                                ),
                              ),
                              //Manufacture year list
                              Container(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.06,
                                    right: deviceWidth * 0.06,
                                    top: 10,
                                    bottom: 10),
                                child: DropdownButtonFormField(
                                  value: car.modelYear,
                                  hint: Text('Choose a manufacture year'),
                                  menuMaxHeight: deviceHeight * 0.2,
                                  items: years,
                                  onChanged: (value) {
                                    setState(() {
                                      year = value!;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (year == 0) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                              ),
                              //Update button
                              Visibility(
                                visible: !(vendor.id == -1 &&
                                    model.id == -1 &&
                                    cylinder == -1 &&
                                    fuel == -1 &&
                                    colorId == -1 &&
                                    year == 0 &&
                                    vin.isEmpty &&
                                    plateNo.isEmpty),
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                      top: deviceHeight * 0.05,
                                      bottom: deviceHeight * 0.05),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
                                        fixedSize: MaterialStateProperty.all(
                                            Size(deviceWidth * 0.88,
                                                deviceHeight * 0.07)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 125, 190, 178))),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (vendor.id != -1 && model.id == -1) {
                                        setState(() {
                                          err = true;
                                        });
                                      }

                                      if ((model.id != -1 || vendor.id != -1) &&
                                          cylinder == -1) {
                                        setState(() {
                                          err = true;
                                        });
                                      }

                                      print("Update pressed");
                                      if (!err) updateCar();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ]),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getVendorItems() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getLists("https://satc.live/api/General/Cars/Vendors"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              List<dynamic> data = response.getData();
              for (var element in data) {
                vendors.add(DropdownMenuItem(
                  value: Vendor.fromJson(element),
                  child: Text(element["eng_name"]),
                ));
              }
            } else {
              vendors[0] = DropdownMenuItem(
                value: Vendor(id: -1, engName: ""),
                child: Text('Somthing went wrong, please try again later!'),
              );
            }
          } else {
            vendors[0] = DropdownMenuItem(
              value: Vendor(id: -1, engName: ""),
              child: Text('Somthing went wrong, please try again later!'),
            );
          }
        }));
  }

  Future<void> getModelItems() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getLists("https://satc.live/api/General/Cars/Models"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              List<dynamic> data = response.getData();
              for (var element in data) {
                models.add(DropdownMenuItem(
                  value: Model.fromJson(element),
                  child: Text(element["eng_name"]),
                ));
              }
            } else {
              models[0] = DropdownMenuItem(
                value: Model(id: -1, engName: "", carVendorId: -1),
                child: Text('Somthing went wrong, please try again later!'),
              );
            }
          } else {
            models[0] = DropdownMenuItem(
              value: Model(id: -1, engName: "", carVendorId: -1),
              child: Text('Somthing went wrong, please try again later!'),
            );
          }
        }));
  }

  Future<void> getFuelItems() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getLists("https://satc.live/api/General/Cars/FuelTypes"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              List<dynamic> data = response.getData();
              for (var element in data) {
                fuelTypes.add(DropdownMenuItem(
                  value: element["id"],
                  child: Text(element["eng_name"]),
                ));
              }
            } else {
              fuelTypes[0] = DropdownMenuItem(
                value: 0,
                child: Text('Somthing went wrong, please try again later!'),
              );
            }
          } else {
            fuelTypes[0] = DropdownMenuItem(
              value: 0,
              child: Text('Somthing went wrong, please try again later!'),
            );
          }
        }));
  }

  Future<void> getCylinder() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getCylinder(model.id == -1 ? car.carModelId : model.id));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              List<DropdownMenuItem<int>> temp = [];
              for (var element in response.getData()) {
                print(element["name"].toString());
                temp.add(DropdownMenuItem(
                  value: element["id"],
                  child: Text(element["name"].toString()),
                ));
              }
              cylinders = temp;
            } else {
              cylinders[0] = DropdownMenuItem(
                value: 0,
                child: Text('Somthing went wrong, please try again later!'),
              );
            }
          } else {
            cylinders[0] = DropdownMenuItem(
              value: 0,
              child: Text('Somthing went wrong, please try again later!'),
            );
          }
        }));
  }

  Future<void> getColorItems() async {
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices()
        .getLists("https://satc.live/api/General/Cars/Colors"));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in list
              List<dynamic> data = response.getData();
              for (var element in data) {
                colors.add(DropdownMenuItem(
                  value: element["id"],
                  child: element["eng_name"] == null
                      ? Text("Khaki")
                      : Text(element["eng_name"]),
                ));
              }
            } else {
              colors[0] = DropdownMenuItem(
                value: 0,
                child: Text('Somthing went wrong, please try again later!'),
              );
            }
          } else {
            colors[0] = DropdownMenuItem(
              value: 0,
              child: Text('Somthing went wrong, please try again later!'),
            );
          }
        }));
  }

  void getYears() {
    int year = DateTime.now().year;
    int endYear = 1970;

    while (endYear <= year) {
      years.add(DropdownMenuItem(
        value: year,
        child: Text(year.toString()),
      ));
      year--;
    }
  }

  void updateCar() async {
    Car updatedCar = Car(
        vendor.id == -1 ? car.carVendorId : vendor.id,
        model.id == -1 ? car.carModelId : model.id,
        colorId == -1 ? car.carColorId : colorId,
        year == 0 ? car.modelYear : year,
        vin.isEmpty ? car.boardNo : vin,
        plateNo.isEmpty ? car.carLicNo : plateNo,
        cylinder == -1 ? car.cylinderId : cylinder,
        fuel == -1 ? car.carFuleTypeId : fuel);
    //Response obj to store the returned response from registerUser method in ApiServices
    Response? response = (await ApiServices().updateCar(updatedCar, car.id));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (response != null) {
            //if request is successful response status is true
            if (response.status) {
              //Extract data from response and store in RegisterAuth obj
              print("in add car");
              print(response.message);
              //Move to RegisterAuth page and send RegisterAuth (contains step 2 id, sms code) as argument

              Navigator.of(context).pushNamed("/Home");
            } else {
              //if request is not successful and response is flase show error msg
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(response.message),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            }
          } else {
            //if request status code is not 200 and response returned null show error msg
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("An error has occurred, please try again later"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
        }));
  }

  List<DropdownMenuItem<Model>> filterM() {
    return models
        .where((element) =>
            element.value!.carVendorId ==
            (vendor.id == -1 ? car.carVendorId : vendor.id))
        .toList();
  }
}
