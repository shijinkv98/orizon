import 'package:json_annotation/json_annotation.dart';
part 'profileModel.g.dart';
@JsonSerializable()
class ProfileModel {
  String joined;
  String orders;
  String phonenumber;
  String mobileverified;
  String emailverified;
  String latitude;
  String longitude;
  String country;
  String location;

  ProfileModel({this.joined,
    this.country,
    this.emailverified,
    this.latitude,
    this.location,
    this.longitude,
    this.mobileverified,
    this.orders,
    this.phonenumber});

  factory ProfileModel.fromJson(Map<String, dynamic> json)=>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}