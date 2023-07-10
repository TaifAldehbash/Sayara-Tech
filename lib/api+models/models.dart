import 'dart:convert';

//**** Onboarding models ****
//User
class User {
  String name;
  String email;
  String mobile;

  User({
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
      };
}

//Sign in+up authentication
class SignAuthentication {
  String mobileno = "";
  int idStep2 = 0;
  String smscode = "";

  SignAuthentication({required this.idStep2, required this.smscode});

  SignAuthentication.mobileNo(this.mobileno);

  factory SignAuthentication.fromRawJson(String str) =>
      SignAuthentication.fromJson(json.decode(str));

  factory SignAuthentication.fromRawJsonMbile(String str) =>
      SignAuthentication.fromJsonMobile(json.decode(str));

  String toRawJson() => json.encode(toJson());

  String toRawJsonMoblie() => json.encode(toJsonMobile());

  factory SignAuthentication.fromJson(Map<String, dynamic> json) =>
      SignAuthentication(
        idStep2: json["id_step2"],
        smscode: json["smscode"],
      );
  factory SignAuthentication.fromJsonMobile(Map<String, dynamic> json) =>
      SignAuthentication.mobileNo(
        json["mobileno"],
      );

  Map<String, dynamic> toJson() => {
        "mobileno": mobileno,
        "id_step2": idStep2,
        "smscode": smscode,
      };

  Map<String, dynamic> toJsonMobile() => {
        "mobileno": mobileno,
      };
}

//Response of functions
class Response {
  bool status;
  String message;
  String error;
  dynamic data;

  Response({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
  });

  factory Response.fromRawJson(dynamic str) =>
      Response.fromJson(json.decode(str));

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: json["Data"],
      );
  dynamic getData() {
    return data;
  }
}

//**** Profile ****
class UserProfile {
  int customerId;
  String name;
  String engName;
  String phone;
  String email;
  String username;
  double walletBalance;
  Coupon cashBackCoupon;
  Statistics statistics;

  UserProfile({
    required this.customerId,
    required this.name,
    required this.engName,
    required this.phone,
    required this.email,
    required this.username,
    required this.walletBalance,
    required this.cashBackCoupon,
    required this.statistics,
  });

  factory UserProfile.fromRawJson(String str) =>
      UserProfile.fromJson(json.decode(str));

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        customerId: json["customer_id"],
        name: json["name"],
        engName: json["eng_name"],
        phone: json["phone"],
        email: json["email"],
        username: json["username"],
        walletBalance: json["wallet_balance"],
        cashBackCoupon: json["cash_back_coupon"] == null
            ? Coupon(
                code: "",
                isActive: false,
                cashBackMoney: 0,
                desc: "",
                couponSharingMsg: '')
            : Coupon.fromJson(json["cash_back_coupon"]),
        statistics: Statistics.fromJson(json["statistics"]),
      );
}

class Statistics {
  int noOfActiveCars;
  int noOfPaidRequests;
  double totalPaidInvoices;

  Statistics({
    required this.noOfActiveCars,
    required this.noOfPaidRequests,
    required this.totalPaidInvoices,
  });

  factory Statistics.fromRawJson(String str) =>
      Statistics.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        noOfActiveCars: json["no_of_active_cars"],
        noOfPaidRequests: json["no_of_paid_requests"],
        totalPaidInvoices: json["total_paid_invoices"],
      );

  Map<String, dynamic> toJson() => {
        "no_of_active_cars": noOfActiveCars,
        "no_of_paid_requests": noOfPaidRequests,
        "total_paid_invoices": totalPaidInvoices,
      };
}

class Coupon {
  String code;
  bool isActive;
  double cashBackMoney;
  String desc;
  String couponSharingMsg;

  Coupon(
      {required this.code,
      required this.isActive,
      required this.cashBackMoney,
      required this.desc,
      required this.couponSharingMsg});

  factory Coupon.fromRawJson(String str) => Coupon.fromJson(json.decode(str));

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        code: json["code"],
        isActive: json["is_active"],
        cashBackMoney: json["cash_back_money"],
        desc: json["desc"],
        couponSharingMsg: json["coupon_sharing_msg"],
      );
}

//**** Car models ****
//Car
class Car {
  int id = 0;
  int carVendorId = 0;
  int carModelId = 0;
  int carColorId = 0;
  int modelYear = 0;
  String boardNo = '';
  String carLicNo = '';
  int carModelsEngineId = 0;
  int carFuleTypeId = 0;
  bool isActive = false;
  int cylinderId = 0;
  String vendorEgnName = "";
  String modelsEngName = "";
  String colorEngName = "";
  String fuleTypeEngName = "";
  String vendorsBinaryImage = "";

  Car(this.carVendorId, this.carModelId, this.carColorId, this.modelYear,
      this.boardNo, this.carLicNo, this.carModelsEngineId, this.carFuleTypeId);

  Car.init(
    this.id,
    this.carVendorId,
    this.carModelId,
    this.carColorId,
    this.modelYear,
    this.boardNo,
    this.carLicNo,
    this.carFuleTypeId,
    this.isActive,
    this.cylinderId,
    this.vendorEgnName,
    this.modelsEngName,
    this.colorEngName,
    this.fuleTypeEngName,
    this.vendorsBinaryImage,
  );

  factory Car.fromRawJson(String str) => Car.fromJson(json.decode(str));

  factory Car.fromRawJson2(String str) => Car.fromJson2(json.decode(str));

  String toRawJson() => json.encode(toJson());

  String toRawJson2() => json.encode(toJson2());

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        json["Car_Vendor_id"],
        json["Car_Model_id"],
        json["Car_Color_id"],
        json["Model_Year"],
        json["Board_No"],
        json["Car_Lic_No"],
        json["Car_Models_Engine_id"],
        json["Car_Fule_Type_id"],
      );

  Map<String, dynamic> toJson() => {
        "Car_Vendor_id": carVendorId,
        "Car_Model_id": carModelId,
        "Car_Models_Engine_id": carModelsEngineId,
        "Car_Fule_Type_id": carFuleTypeId,
        "Car_Color_id": carColorId,
        "Model_Year": modelYear,
        "Board_No": boardNo,
        "Car_Lic_No": carLicNo,
      };

  factory Car.fromJson2(Map<String, dynamic> json) => Car.init(
        json["id"],
        json["Car_Vendor_id"],
        json["Car_Model_id"],
        json["Car_Color_id"],
        json["Model_Year"],
        json["Board_No"],
        json["Car_Lic_No"],
        json["Car_Fule_Type_id"],
        json["is_active"],
        json["Cylinder_id"],
        json["Vendor_egn_name"],
        json["Models_eng_name"],
        json["color_eng_name"],
        json["Fule_Type_eng_name"],
        json["Vendors_binary_image"],
      );

  Map<String, dynamic> toJson2() => {
        "id": id,
        "Car_Vendor_id": carVendorId,
        "Car_Model_id": carModelId,
        "Car_Color_id": carColorId,
        "Model_Year": modelYear,
        "Board_No": boardNo,
        "Car_Lic_No": carLicNo,
        "Car_Fule_Type_id": carFuleTypeId,
        "is_active": isActive,
        "Cylinder_id": cylinderId,
        "Vendor_egn_name": vendorEgnName,
        "Models_eng_name": modelsEngName,
        "color_eng_name": colorEngName,
        "Fule_Type_eng_name": fuleTypeEngName,
        "Vendors_binary_image": vendorsBinaryImage,
      };
}

//Car vendor
class Vendor {
  int id;
  String engName;

  Vendor({
    required this.id,
    required this.engName,
  });

  factory Vendor.fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        engName: json["eng_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eng_name": engName,
      };
}

//Car model
class Model {
  int id;
  String engName;
  int carVendorId;

  Model({
    required this.id,
    required this.engName,
    required this.carVendorId,
  });

  factory Model.fromRawJson(String str) => Model.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        engName: json["eng_name"],
        carVendorId: json["car_vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eng_name": engName,
        "car_vendor_id": carVendorId,
      };
}
