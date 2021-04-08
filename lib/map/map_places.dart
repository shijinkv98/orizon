import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPlacePicker extends StatefulWidget {
  @override
  State<MapPlacePicker> createState() => _MapPlaceState();
}

class _MapPlaceState extends State<MapPlacePicker> {
  Completer<GoogleMapController> _controller = Completer();
  double _latitude = 37.4279, _longitude = -122.08574;


  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      _latitude = value.latitude;
      _longitude = value.longitude;
      _goToTheLake();
    }).catchError((error) => print('MJM determinePosition excep: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            // myLocationButtonEnabled: true,
            // myLocationEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(_latitude, _longitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              debugPrint('MJM onMapCreated()');
            },
            onCameraMoveStarted: () => debugPrint('MJM onCameraMoveStarted()'),
            onCameraMove: (position) {
              _latitude = position.target.latitude;
              _longitude = position.target.longitude;
              debugPrint(
                  'MJM GoogleMap onCameraMove ${position.target.latitude}  -   ${position.target.longitude}');
            },
            onCameraIdle: () {
              placemarkFromCoordinates(_latitude, _longitude).then((value) {
                debugPrint(
                    'MJM address: ${value.first?.name}, ${value.first?.street}');
              });
              debugPrint('MJM GoogleMap onCameraIdle');
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_latitude, _longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings().then((value) async {
        if (value) {
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission != LocationPermission.whileInUse &&
                permission != LocationPermission.always) {
              return Future.error(
                  'Location permissions are denied (actual value: $permission).');
            }
          }
          return await Geolocator.getCurrentPosition();
        } else {
          return Future.error('Location services are disabled.');
        }
      });
      // return Future.error('Location services are disabled.');
    } else {
      return await Geolocator.getCurrentPosition();
    }
  }
}
