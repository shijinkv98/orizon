import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:geolocator/geolocator.dart';
import 'package:vendor_app/screens/register/testList.dart';

String finalAddress ='Searching Current Location...';

class  GenerateMaps extends ChangeNotifier{
  Position position;

  Future getCurrentLocation()async{

    var positionData = await GeolocatorPlatform.instance.getCurrentPosition();
    final cords = geoCo.Coordinates(positionData.latitude,positionData.longitude);
    var address = await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);

    //String adresses=address.first.addressLine;

    String mainAddress = address.first.addressLine.split(',')[0];

    print(mainAddress);
    finalAddress = mainAddress;
    notifyListeners();
  }

}