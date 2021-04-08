import 'package:vendor_app/model/user.dart';

class SubscribeResponse {
  int success;
  String message;
  // List<Reasons> reasons;
  SubscribeResponse.fromJson(Map<String, dynamic> json) {

    message = json['message'];
    success = json['success'];

  }
}
