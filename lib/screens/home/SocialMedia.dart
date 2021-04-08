// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// Future<Album> createAlbum(String title) async {
//   final http.Response response = await http.post(
//     'http://xshop.alisonsdemo.tk/update-social-media',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );
//
//   if (response.statusCode == 201) {
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to create album.');
//   }
// }
//
// class Album {
//   final String whatsapp;
//   final String facebook;
//   final String instagram;
//   final String youtube;
//   final String website_url;
//
//   Album({this.facebook, this.whatsapp,this.instagram,this.website_url,this.youtube});
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       facebook: json['facebook'],
//       whatsapp: json['whatsapp'],
//       instagram: json['instagram'],
//       website_url: json['website_url'],
//       youtube: json['youtube'],
//     );
//   }
// }
//
//
//
// class SocialMedia extends StatefulWidget {
//   SocialMedia({Key key}) : super(key: key);
//
//   @override
//   _MyAppState createState() {
//     return _MyAppState();
//   }
// }
//
// class _MyAppState extends State<SocialMedia> {
//   final TextEditingController _controller = TextEditingController();
//   Future<Album> _futureAlbum;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           // title: Text('Create Data Example'),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: (_futureAlbum == null)
//               ? Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(hintText: 'Enter Title'),
//               ),
//               ElevatedButton(
//                 child: Text('Create Data'),
//                 onPressed: () {
//                   setState(() {
//                     _futureAlbum = createAlbum(_controller.text);
//                   });
//                 },
//               ),
//             ],
//           )
//               : FutureBuilder<Album>(
//             future: _futureAlbum,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data.title);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }
//
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }