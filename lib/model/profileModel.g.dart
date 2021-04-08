// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    joined: json['joined'] as String,
    country: json['country'] as String,
    emailverified: json['emailverified'] as String,
    latitude: json['latitude'] as String,
    location: json['location'] as String,
    longitude: json['longitude'] as String,
    mobileverified: json['mobileverified'] as String,
    orders: json['orders'] as String,
    phonenumber: json['phonenumber'] as String,
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'joined': instance.joined,
      'orders': instance.orders,
      'phonenumber': instance.phonenumber,
      'mobileverified': instance.mobileverified,
      'emailverified': instance.emailverified,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'country': instance.country,
      'location': instance.location,
    };
