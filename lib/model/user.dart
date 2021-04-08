class UserData {
  String id, mobile, name, email, locationDetails, token;
  int status, otpVerificationStatus, emailVerificationStatus;
  String otp;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    name = json['name'];
    email = json['email'];
    status = json['status'];
    locationDetails = json['location_details'];
    token = json['token'];
    otp = json['otp'].toString();
    otpVerificationStatus = json['otpverificationstatus'];
    // emailVerificationStatus = json['emailverificationstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['status'] = this.status;
    data['location_details'] = this.locationDetails;
    data['token'] = this.token;
    data['otp'] = this.otp;
    // data['location'] = this.location;
    data['email'] = this.email;
    data['otpverificationstatus'] = this.otpVerificationStatus;
    // data['emailverificationstatus'] = this.emailVerificationStatus;
    return data;
  }
}
