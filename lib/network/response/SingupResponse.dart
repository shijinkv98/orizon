import 'package:vendor_app/model/user.dart';

class SignupResponse {
  UserData vendorData;
  int success;
  String message;
  // List<Reasons> reasons;
  SignupResponse.fromJson(Map<String, dynamic> json) {
    if (json['vendordata'] != null) {
      vendorData = UserData.fromJson(json['vendordata']);
    }
    message = json['message'];
    success = json['success'];
    // if (json['reasons'] != null) {
    //   reasons = (json['reasons'] as List)
    //       .map((reasonsJson) => Reasons.fromJson(reasonsJson))
    //       .toList();
    // }
  }
}
