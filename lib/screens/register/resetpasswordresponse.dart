class ResetPasswordResponse {
  int success;
  String message;
  String mobile;
  String email;

  ResetPasswordResponse({this.success, this.message, this.mobile, this.email});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
