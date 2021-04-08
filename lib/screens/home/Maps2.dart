// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
//
// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Map",
//       home: MapActivity(),
//     );
//   }
// }
//
// class MapActivity extends StatefulWidget {
//   @override
//   _MapActivityState createState() => _MapActivityState();
// }
//
// class _MapActivityState extends State<MapActivity> {
//   LatLng _center ;
//   Position currentLocation;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getUserLocation();
//   }
//
//   Future<Position> locateUser() async {
//     return Geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
//
//   getUserLocation() async {
//     currentLocation = await locateUser();
//     setState(() {
//       _center = LatLng(currentLocation.latitude, currentLocation.longitude);
//     });
//     print('center $_center');
//   }
//
//   noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }