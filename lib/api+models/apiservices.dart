import 'package:http/http.dart' as http;
import 'package:sayaratech/api+models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  late Response model;
  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', value);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  //Register new user in api and return response
  Future<Response?> registerUser(User user) async {
    var url = Uri.parse(
        "https://satc.live/api/General/Customers/NewRegistrationStep1");
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'lng': 'en'
        },
        body: user.toRawJson());
    print(user.toRawJson());
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in registerUser responce data is ");
      print(model.data);
      print(model.message);
      return model;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return null;
  }

  //Authenticate newly registered user in api and return true if authenticated and false otherwise
  Future<bool> authenticate(SignAuthentication auth) async {
    int stepId = auth.idStep2;
    String smsCode = auth.smscode;
    print("in auth");
    var url = Uri.parse(
        "https://satc.live/api/General/Customers/NewRegistrationStep2?step1id=$stepId&smscode=$smsCode");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'lng': 'en'
      },
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in authenticate responce data is ");
      print(model.data);
      if (model.status) {
        await setToken(model.getData());
      }
      return model.status;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return false;
  }

  //Sign in user in api and return response
  Future<Response?> signinUser(SignAuthentication sign) async {
    var mobile = sign.mobileno;
    var url = Uri.parse(
        "https://satc.live/api/Auth/Token/AuthenticateBySMSStep1?mobileno=$mobile");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'lng': 'en'
      },
    );
    print(sign.toRawJsonMoblie());
    if (response.statusCode == 200) {
      print(response.body);
      model = Response.fromRawJson(response.body);
      print("in registerUser responce data is ");
      print(model.data);
      return model;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return null;
  }

  //Authenticate newly registered user in api and return true if authenticated and false otherwise
  Future<bool> signinAuth(SignAuthentication sign) async {
    int stepId = sign.idStep2;
    String smsCode = sign.smscode;
    String mobile = sign.mobileno;
    print("in signinAuth");
    var url = Uri.parse(
        "https://satc.live/api/Auth/Token/AuthenticateBySMSStep2?mobileno=$mobile&step1id=$stepId&smscode=$smsCode");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'lng': 'en',
      },
    );
    print(sign.toRawJson());
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in registerUser responce data is ");
      print(response.body);
      if (model.status) {
        await setToken(model.getData());
      }
      return model.status;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return false;
  }

  //Refresh expired token in api and return new token
  Future<Response?> refreshAuth() async {
    String? token = await getToken();
    var url = Uri.parse("https://satc.live/api/Auth/Token/refreshToken");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'lng': 'en',
        'token': token!,
      },
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in refreshAuth responce data is ");
      print(model.message);
      return model;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return model;
  }

//Get user profile from api
  Future<Response?> getFromApi(String uri) async {
    String? token = await getToken();
    var url = Uri.parse(uri);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'lng': 'en',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in getFromApi responce data is ");
      print(model.error);
      return model;
    } else {
      print("response not 200");
      print(response.statusCode);
    }
    return model;
  }

  //Add new car to api
  Future<Response?> addCar(Car car) async {
    print(car.toRawJson());
    String? token = await getToken();
    var url = Uri.parse("https://satc.live/api/Customer/AddCar");

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'lng': 'en',
        'authorization': 'Bearer $token',
      },
      body: car.toRawJson(),
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in addCar responce data is ");
      print(response.body);
      return model;
    } else {
      print("response not 200");
      print(response.reasonPhrase);
    }

    return null;
  }

  //Updatecar to api
  Future<Response?> updateCar(Car car, int id) async {
    String? token = await getToken();

    var url = Uri.parse("https://satc.live/api/Customer/UpdaetCar?id=$id");

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'lng': 'en',
        'authorization': 'Bearer $token',
      },
      body: car.toRawJson(),
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in addCar responce data is ");
      print(response.body);
      return model;
    } else {
      print("response not 200");
      print(response.reasonPhrase);
    }

    return null;
  }

  //Get car vendors/ models/ colors/ fuel
  Future<Response?> getLists(String uri) async {
    var url = Uri.parse(uri);
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'lng': 'en',
      },
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in getLists");
      return model;
    } else {
      print("response not 200");
      print(response.reasonPhrase);
    }
    return null;
  }

  //Get car Cylinder count
  Future<Response?> getCylinder(int modelId) async {
    var url = Uri.parse(
        "https://satc.live/api/General/Cars/Models/Cylinder/$modelId");
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'lng': 'en',
      },
    );
    if (response.statusCode == 200) {
      model = Response.fromRawJson(response.body);
      print("in getLists");
      return model;
    } else {
      print("response not 200");
      print(response.reasonPhrase);
    }
    return null;
  }
}
