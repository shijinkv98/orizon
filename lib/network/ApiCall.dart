import 'dart:convert';
import 'dart:io';

import 'package:vendor_app/helpers/constants.dart';
// import 'package:driver_app/notifier/home/duty_notifier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/response/low_stock_product_list_response.dart';
import 'package:vendor_app/network/response/outof_stock_product_list_response.dart';
import 'package:vendor_app/network/response/pending_product_list_response.dart';
import 'package:vendor_app/screens/register/forgotresponse.dart';
import 'package:vendor_app/screens/products/pendingproducts.dart';
import 'package:vendor_app/screens/products/products%20copy.dart';
import 'package:vendor_app/screens/products/products.dart';
import 'package:vendor_app/screens/register/resetpasswordresponse.dart';

import 'response/SingupResponse.dart';
import 'response/category_response.dart';
import 'response/dashboard_response.dart';
import 'response/order_list_response.dart';
import 'response/product_list_response.dart';

// import 'response/age_restriction_response.dart';
// import 'response/balance_response.dart';
// import 'response/success_response.dart';
// import 'response/tasks_response.dart';
// import 'response/tasks_update_response.dart';
// import 'response/update_profile_response.dart';
// import 'response/user_response.dart';
// import 'response/history_response.dart';

// typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);
  String mStoreSlug = '';
class ApiCall {
  static const API_URL = "${BASE_URL}api/";

  ApiCall._privateConstructor();
  static final ApiCall _instance = ApiCall._privateConstructor();
  factory ApiCall() {
    return _instance;
  }

  BuildContext context;



  MultipartRequest getMultipartRequest(String url) {
    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    return http.MultipartRequest('POST', Uri.parse(url));
  }
  Future<T> executeAdmanager<T, K>(String url,Map params,
      {
        bool isGet = false, MultipartRequest multipartRequest}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isConnected = false;
    }

    if (!isConnected) {
      return Future.error(Exception('No Connection'));
    }

    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    debugPrint("URL: " + url);
    if (params == null) {
      params = Map();
    }


    http.Response response;
    if (multipartRequest != null) {
      debugPrint("params mulipart: " + multipartRequest.fields.toString());
      if (multipartRequest.files != null && multipartRequest.files.isNotEmpty) {
        multipartRequest.files.forEach((element) {
          debugPrint(
              "params mulipart file: ${element.field} : ${element?.filename} contentType: ${element.contentType}");
        });
      }

      var streamedResponse = await multipartRequest.send();
      response = await http.Response.fromStream(streamedResponse);
      if (T == Null) {
        return null;
      }
    } else {
      debugPrint("params: " + params.toString());
      response =
      isGet ? await http.get(url) : await http.post(url, body: params);
    }

    String responsStr = response.body != null && response.body.trim().isNotEmpty
        ? response.body
        : '{}';
    debugPrint("response: " + response.body);

    var jsonResponse = json.decode(responsStr);

    // int success = jsonResponse.containsKey('succes') ? jsonResponse['success'] : 1;
    String success = jsonResponse['success']?.toString() ?? '1';

    showAlert(jsonResponse['alert_message']);

    if (success == '1') {
      showToast(jsonResponse['message']);

      print(jsonResponse.toString());
      return jsonResponse;
    } else {
      showToast(jsonResponse['message'] ?? "Something went wrong!");
      if (success == '2' && context != null) {
        await saveUser("");
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (success == '3') {
        // Provider.of<DutyChangeNotifier>(context, listen: false).isDutyOn =
        //     false;
        return fromJson<T, K>(jsonResponse);
      }
      return Future.error(Exception('Failed to load post'));
    }
  }

  Future<T> executeNew<T, K>(String url, String userId,String userToken,Map params,String slug,
      {
        bool isGet = false, MultipartRequest multipartRequest}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isConnected = false;
    }

    if (!isConnected) {
      return Future.error(Exception('No Connection'));
    }

    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    debugPrint("URL: " + url);
    if (params == null) {
      params = Map();
    }
    if (multipartRequest != null) {
      multipartRequest?.fields['token'] = userToken.trim();
      multipartRequest?.fields['id'] = userId.toString();
    }

    http.Response response;
    if (multipartRequest != null) {
      debugPrint("params mulipart: " + multipartRequest.fields.toString());
      if (multipartRequest.files != null && multipartRequest.files.isNotEmpty) {
        multipartRequest.files.forEach((element) {
          debugPrint(
              "params mulipart file: ${element.field} : ${element?.filename} contentType: ${element.contentType}");
        });
      }

      var streamedResponse = await multipartRequest.send();
      response = await http.Response.fromStream(streamedResponse);
      if (T == Null) {
        return null;
      }
    } else {
      debugPrint("params: " + params.toString());
      response =
      isGet ? await http.get(url) : await http.post(url, body: params);
    }

    String responsStr = response.body != null && response.body.trim().isNotEmpty
        ? response.body
        : '{}';
    debugPrint("response: " + response.body);

    var jsonResponse = json.decode(responsStr);

    // int success = jsonResponse.containsKey('succes') ? jsonResponse['success'] : 1;
    String success = jsonResponse['success']?.toString() ?? '1';

    showAlert(jsonResponse['alert_message']);

    if (success == '1') {
      showToast(jsonResponse['message']);
      showAlert(jsonResponse['message']);
      showAlertDialogProduct(jsonResponse['message'],slug);

      print(jsonResponse.toString());
      return jsonResponse;
    } else {
      showToast(jsonResponse['message'] ?? "Something went wrong!");
      if (success == '2' && context != null) {
        await saveUser("");
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (success == '3') {
        // Provider.of<DutyChangeNotifier>(context, listen: false).isDutyOn =
        //     false;
        return fromJson<T, K>(jsonResponse);
      }
      return Future.error(Exception('Failed to load post'));
    }
  }
  Future<T> executeImageAdd<T, K>(String url, String userId,String userToken,String admagerId,Map params,
      {
        bool isGet = false, MultipartRequest multipartRequest}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isConnected = false;
    }

    if (!isConnected) {
      return Future.error(Exception('No Connection'));
    }

    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    debugPrint("URL: " + url);
    if (params == null) {
      params = Map();
    }
    if (multipartRequest != null) {
      multipartRequest?.fields['token'] = userToken.trim();
      multipartRequest?.fields['id'] = userId.toString();
      multipartRequest?.fields['ad_manager_id'] = admagerId.toString();
    }

    http.Response response;
    if (multipartRequest != null) {
      debugPrint("params mulipart: " + multipartRequest.fields.toString());
      if (multipartRequest.files != null && multipartRequest.files.isNotEmpty) {
        multipartRequest.files.forEach((element) {
          debugPrint(
              "params mulipart file: ${element.field} : ${element?.filename} contentType: ${element.contentType}");
        });
      }

      var streamedResponse = await multipartRequest.send();
      response = await http.Response.fromStream(streamedResponse);
      if (T == Null) {
        return null;
      }
    } else {
      debugPrint("params: " + params.toString());
      response =
      isGet ? await http.get(url) : await http.post(url, body: params);
    }

    String responsStr = response.body != null && response.body.trim().isNotEmpty
        ? response.body
        : '{}';
    debugPrint("response: " + response.body);

    var jsonResponse = json.decode(responsStr);

    // int success = jsonResponse.containsKey('succes') ? jsonResponse['success'] : 1;
    String success = jsonResponse['success']?.toString() ?? '1';

    showAlert(jsonResponse['alert_message']);

    if (success == '1') {
      showToast(jsonResponse['message']);

      print(jsonResponse.toString());
      return jsonResponse;
    } else {
      showToast(jsonResponse['message'] ?? "Something went wrong!");
      if (success == '2' && context != null) {
        await saveUser("");
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (success == '3') {
        // Provider.of<DutyChangeNotifier>(context, listen: false).isDutyOn =
        //     false;
        return fromJson<T, K>(jsonResponse);
      }
      return Future.error(Exception('Failed to load post'));
    }
  }
  Future<T> execute<T, K>(String url, Map params,
      {
        bool isGet = false, MultipartRequest multipartRequest}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isConnected = false;
    }

    if (!isConnected) {
      showToast("Not Connected to Internet");
      return Future.error(Exception('No Connection'));
    }

    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    debugPrint("URL: " + url);
    if (params == null) {
      params = Map();
    }

    var user = await ApiCall().getUser();
    if (user != null) {
      if (user.token != null && user.token.trim().isNotEmpty) {
        params.addAll({'token': user.token.trim()});
        if (multipartRequest != null)
          multipartRequest?.fields['token'] = user.token.trim();
      }
      if (user.id != null && user.id.trim().isNotEmpty) {
        params.addAll({'id': user.id.toString()});
        if (multipartRequest != null)
          multipartRequest?.fields['id'] = user.id.toString();
      }
    }

    http.Response response;
    if (multipartRequest != null) {
      debugPrint("params mulipart: " + multipartRequest.fields.toString());
      if (multipartRequest.files != null && multipartRequest.files.isNotEmpty) {
        multipartRequest.files.forEach((element) {
          debugPrint(
              "params mulipart file: ${element.field} : ${element?.filename} contentType: ${element.contentType}");
        });
      }

      var streamedResponse = await multipartRequest.send();
      response = await http.Response.fromStream(streamedResponse);
      if (T == Null) {
        return null;
      }
    } else {
      debugPrint("params: " + params.toString());
      response =
          isGet ? await http.get(url) : await http.post(url, body: params);
    }

    String responsStr = response.body != null && response.body.trim().isNotEmpty
        ? response.body
        : '{}';
    debugPrint("response: " + response.body);

    var jsonResponse = json.decode(responsStr);

    // int success = jsonResponse.containsKey('succes') ? jsonResponse['success'] : 1;
    String success = jsonResponse['success']?.toString() ?? '1';

    showAlert(jsonResponse['alert_message']);

    if (success == '1') {
      showToast(jsonResponse['message']);

      print(jsonResponse.toString());
      return fromJson<T, K>(jsonResponse);
    } else {
      showToast(jsonResponse['message'] ?? "Something went wrong!");
      if (success == '2' && context != null) {
        await saveUser("");
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (success == '3') {
        // Provider.of<DutyChangeNotifier>(context, listen: false).isDutyOn =
        //     false;
        return fromJson<T, K>(jsonResponse);
      }
      return Future.error(Exception('Failed to load post'));
    }
  }
  Future<T> qpprove_reject<T, K>(String url, Map params,
      {
        bool isGet = false, MultipartRequest multipartRequest}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isConnected = false;
    }

    if (!isConnected) {
      return Future.error(Exception('No Connection'));
    }

    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    debugPrint("URL: " + url);
    if (params == null) {
      params = Map();
    }

    var user = await ApiCall().getUser();
    if (user != null) {
      if (user.token != null && user.token.trim().isNotEmpty) {
        params.addAll({'token': user.token.trim()});
        if (multipartRequest != null)
          multipartRequest?.fields['token'] = user.token.trim();
      }
      if (user.id != null && user.id.trim().isNotEmpty) {
        params.addAll({'id': user.id.toString()});
        if (multipartRequest != null)
          multipartRequest?.fields['id'] = user.id.toString();
      }
    }
    http.Response response;
    if (multipartRequest != null) {
      debugPrint("params mulipart: " + multipartRequest.fields.toString());
      if (multipartRequest.files != null && multipartRequest.files.isNotEmpty) {
        multipartRequest.files.forEach((element) {
          debugPrint(
              "params mulipart file: ${element.field} : ${element?.filename} contentType: ${element.contentType}");
        });
      }

      var streamedResponse = await multipartRequest.send();
      response = await http.Response.fromStream(streamedResponse);
      if (T == Null) {
        return null;
      }
    } else {
      debugPrint("params: " + params.toString());
      response =
      isGet ? await http.get(url) : await http.post(url, body: params);
    }

    String responsStr = response.body != null && response.body.trim().isNotEmpty
        ? response.body
        : '{}';
    debugPrint("response: " + response.body);

    var jsonResponse = json.decode(responsStr);

    // int success = jsonResponse.containsKey('succes') ? jsonResponse['success'] : 1;
    String success = jsonResponse['success']?.toString() ?? '1';

    showAlert(jsonResponse['alert_message']);

    if (success == '1') {
      showToast(jsonResponse['message']);

      print(jsonResponse.toString());
      return fromJson<T, K>(jsonResponse);
    } else {
      showToast(jsonResponse['message'] ?? "Something went wrong!");
      if (success == '2' && context != null) {
        await saveUser("");
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (success == '3') {
        // Provider.of<DutyChangeNotifier>(context, listen: false).isDutyOn =
        //     false;
        return fromJson<T, K>(jsonResponse);
      }
      return Future.error(Exception('Failed to load post'));
    }
  }
  Future saveUser(String userResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('save user resp: $userResponse');
    bool success = await prefs.setString('user', userResponse);
    return success;
  }

  Future saveAdminPhone(String adminNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('save admin phone NO: $adminNo');
    bool success = await prefs.setString('admin_phone_no', adminNo);
    return success;
  }

  Future<String> getAdminPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_phone_no');
  }

  Future<UserData> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user =
        prefs.getString('user') == null ? "" : prefs.getString('user');
    if (user == null || user.trim().isEmpty) {
      return null;
    }
    return UserData.fromJson(json.decode(user == null ? "" : user));
  }

  Future<String> getUserToken() async {
    String token;
    var user = await ApiCall().getUser();
    if (user != null && user.token != null && user.token.trim().isNotEmpty) {
      token = user.token;
    }
    return token;
  }

  /// If T is a List, K is the subtype of the list.
  T fromJson<T, K>(dynamic json) {
    if (json is Iterable) {
      return _fromJsonList<K>(json) as T;
    } else if (T == SignupResponse) {
      return SignupResponse.fromJson(json) as T;
    } else if (T == DashboardResponse) {
      return DashboardResponse.fromJson(json) as T;
    } else if (T == OrdersListResponse) {
      return OrdersListResponse.fromJson(json) as T;
    } else if (T == OrderPagination) {
      return OrderPagination.fromJson(json) as T;
    } else if (T == OrderDetailsResponse) {
      return OrderDetailsResponse.fromJson(json) as T;
    } else if (T == CategoryResponse) {
      return CategoryResponse.fromJson(json) as T;
    } else if (T == ProductListResponse) {
      return ProductListResponse.fromJson(json) as T;
      } else if (T == PendingProductResponse) {
        return PendingProductResponse.fromJson(json) as T;
    } else if (T == LowStockProductsResponse) {
      return LowStockProductsResponse.fromJson(json) as T;
    } else if (T == ResetPasswordResponse) {
      return ResetPasswordResponse.fromJson(json) as T;
    } else if (T == ForgotResponse) {
      return ForgotResponse.fromJson(json) as T;
    } else if (T == OutofStockProductsResponse) {
      return OutofStockProductsResponse.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
      // } else if (T == Message) {
      //   return Message.fromJson(json) as T;
    }
    else {
      return json;
      //showToast("Something went wrong!");
      // throw Exception("Unknown class");
      // Future.error(Exception('Unknown class'));
    }
    // else {
    //   showToast("Something went wrong!");
    //   throw Exception("Unknown class");
    //   // Future.error(Exception('Unknown class'));
    // }
  }

  void showToast(String message) {
    if (message == null ||
        message.trim().isEmpty ||
        message.trim().toLowerCase() == "success") {
      return;
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  void showAlertDialogProduct(String message,String slug){

    if (message == null ||
        message.trim().isEmpty ||
        message.trim().toLowerCase() == "success") {
      return;
    }
    showDialog(

      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Product Created Successfully"),
        // content: Text("See products pending for approval"),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        // PendingProductsScreen(mStoreSlug)
                    ProductsScreen()),
                  );
                },
                child: Text("okay"),
              ),
              // FlatButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => ProductsScreen()),
              //     );
              //   },
              //   child: Text("Cancel"),
              // ),
            ],
          ),
        ],
      ),
    );
  }



  void showAlert(String message) {
    if (message == null ||
        message.trim().isEmpty ||
        message.trim().toLowerCase() == "success") {
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {}
  }

  List<K> _fromJsonList<K>(List jsonList) {
    if (jsonList == null) {
      return null;
    }

    List<K> output = List();

    for (Map<String, dynamic> json in jsonList) {
      output.add(fromJson(json));
    }

    return output;
  }
}
