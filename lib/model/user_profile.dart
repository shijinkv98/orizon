// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.success,
    this.message,
    this.joined,
    this.orders,
    this.profilePhoto,
    this.phoneNumber,
    this.mobileVerified,
    this.emailVerified,
    this.latitude,
    this.longtitude,
    this.country,
    this.location,
    this.storeVerifiedStatus,
    this.vendorSocialMedia,
    this.editProfile,
    this.changeVendorPassword,
    this.logout,
  });

  int success;
  String message;
  String joined;
  int orders;
  String profilePhoto;
  String phoneNumber;
  String mobileVerified;
  String emailVerified;
  dynamic latitude;
  dynamic longtitude;
  dynamic country;
  String location;
  int storeVerifiedStatus;
  List<dynamic> vendorSocialMedia;
  String editProfile;
  String changeVendorPassword;
  String logout;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    success: json["success"],
    message: json["message"],
    joined: json["joined"],
    orders: json["orders"],
    profilePhoto: json["profile_photo"],
    phoneNumber: json["phone_number"],
    mobileVerified: json["mobile_verified"],
    emailVerified: json["email_verified"],
    latitude: json["latitude"],
    longtitude: json["longtitude"],
    country: json["country"],
    location: json["location"],
    storeVerifiedStatus: json["store_verified_status"],
    vendorSocialMedia: List<dynamic>.from(json["vendor_social_media"].map((x) => x)),
    editProfile: json["edit_profile"],
    changeVendorPassword: json["change_vendor_password"],
    logout: json["logout"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "joined": joined,
    "orders": orders,
    "profile_photo": profilePhoto,
    "phone_number": phoneNumber,
    "mobile_verified": mobileVerified,
    "email_verified": emailVerified,
    "latitude": latitude,
    "longtitude": longtitude,
    "country": country,
    "location": location,
    "store_verified_status": storeVerifiedStatus,
    "vendor_social_media": List<dynamic>.from(vendorSocialMedia.map((x) => x)),
    "edit_profile": editProfile,
    "change_vendor_password": changeVendorPassword,
    "logout": logout,
  };
}
