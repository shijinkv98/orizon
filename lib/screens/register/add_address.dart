// import 'package:flutter/material.dart';
//
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/entities/location_result.dart';
//
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   LocationResult _pickedLocation;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
// //      theme: ThemeData.dark(),
//       title: 'location picker',
//       localizationsDelegates: const [
//         location_picker.S.delegate,
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const <Locale>[
//         Locale('en', ''),
//         Locale('ar', ''),
//         Locale('pt', ''),
//         Locale('tr', ''),
//         Locale('es', ''),
//         Locale('it', ''),
//         Locale('ru', ''),
//       ],
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('location picker'),
//         ),
//         body: Builder(builder: (context) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 RaisedButton(
//                   onPressed: () async {
//                     LocationResult result = await showLocationPicker(
//                       context,
//                       apiKey,
//                       initialCenter: LatLng(31.1975844, 29.9598339),
// //                      automaticallyAnimateToCurrentLocation: true,
// //                      mapStylePath: 'assets/mapStyle.json',
//                       myLocationButtonEnabled: true,
//                       // requiredGPS: true,
//                       layersButtonEnabled: true,
//                       // countries: ['AE', 'NG']
//
// //                      resultCardAlignment: Alignment.bottomCenter,
//                       desiredAccuracy: LocationAccuracy.best,
//                     );
//                     print("result = $result");
//                     setState(() => _pickedLocation = result);
//                   },
//                   child: Text('Pick location'),
//                 ),
//                 Text(_pickedLocation.toString()),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }