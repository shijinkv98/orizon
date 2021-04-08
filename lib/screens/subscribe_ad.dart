// // import 'dart:convert';
// // import 'dart:convert';
// // import 'dart:io' show Platform;
// import 'dart:io';
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:vendor_app/custom/fdottedline.dart';
// import 'package:vendor_app/helpers/constants.dart';
// import 'package:vendor_app/main.dart';
// import 'package:vendor_app/screens/UploadImageDemo.dart';
// import 'package:image_picker/image_picker.dart';
// import 'ImageGallery_1.dart';
// import 'home/UploadPage.dart';
// import 'home/SocialMedia.dart';
//
// class SubscribeAds extends StatelessWidget {
//   File image;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
//   @override
//   Widget build(BuildContext context) {
//     String videoUrl;
//     final videoUrlField = TextFormField(
//       obscureText: false,
//       onSaved: (value) {
//         videoUrl = value;
//       },
//       style: style,
//       validator: (value) {
//         if (value.trim().isEmpty) {
//           return 'This field is required';
//           // } else if (!RegExp(
//           //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//           //     .hasMatch(value)) {
//           //   return 'Invalid email';
//         } else if (value.trim().length != 8) {
//           return 'Invalid Mobile number';
//         } else {
//           return null;
//         }
//       },
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//         hintText: "Youtube url",
//         labelText: 'Youtube url link',
//       ),
//     );
//
//     var _bannerTypes = ['Categoty', 'Product', 'External link'];
//     String bannerType;
//     final bannerTypeField = DropdownButtonFormField(
//       value: bannerType,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//         hintText: 'Banner type',
//         labelText: 'Banner redirection type',
//       ),
//       isDense: true,
//       onChanged: (String newValue) {
//         // setState(() {
//         bannerType = newValue;
//         // state.didChange(newValue);
//         // });
//       },
//       items: _bannerTypes.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//
//     var _categories = ['Categoty 1', 'Categoty 2', 'Categoty 3'];
//     String _category;
//     final categoryField = DropdownButtonFormField(
//       value: _category,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//         hintText: 'Select a category',
//         labelText: 'Category',
//       ),
//       isDense: true,
//       onChanged: (String newValue) {
//         // setState(() {
//         _category = newValue;
//         // state.didChange(newValue);
//         // });
//       },
//       items: _categories.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//
//     final submitButon = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(5.0),
//       color: colorPrimary,
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//         onPressed: () async {
//           // Navigator.of(context).pushReplacementNamed('/home');
//           if (_formKey.currentState.validate()) {
//             _formKey.currentState.save();
//             // Navigator.of(context).pushReplacementNamed('home');
//           }
//         },
//         child: Text("Submit",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         // actions: <Widget>[
//         //   IconButton(
//         //     icon: Icon(
//         //       Icons.image,
//         //       color: Colors.white,
//         //     ),
//         //     onPressed: () {
//         //     Navigator.push(context,MaterialPageRoute(builder: (context) => UploadPage()),);
//         //     },
//         //   )
//         // ],
//
//         // title: Text(
//         //   'Subscribe',
//         //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         // ),
//
//         backgroundColor: colorPrimary,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Text(
//                       "Promotion Banners",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//                     ),
//                     Container(
//                       child: image == null ? Text('No Image Showing') : Image.file(image),
//                     ),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Text(
//                       "Promotion Banners",
//                       style: TextStyle(color: Colors.black, fontSize: 14),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//
//                     FDottedLine(
//                       color: colorPrimary,
//                       strokeWidth: 2.0,
//                       dottedLength: 5.0,
//                       space: 3.0,
//                       corner: FDottedLineCorner.all(6.0),
//
//                       /// add widget
//                       child: Container(
//                         color: Colors.white,
//                         width: double.infinity,
//                         height: 100,
//                         alignment: Alignment.center,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(icon:Icon(Icons.add,
//                               size: 30,color: primaryTextColor),
//                               onPressed: () {
//                                 Navigator.push(context,MaterialPageRoute(builder: (context) => UploadImageDemo()),);
//                                 // showDialog(
//                                 //   context: context,
//                                 //   builder: (BuildContext context) => _buildAboutDialog(context),
//                                 // );
//                                 // Perform some action
//                               },
//
//
//                             ),
//
//                             Text(
//                               'Upload Image',
//                               style: TextStyle(
//                                   fontSize: 12, color: primaryTextColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     SizedBox(
//                       height: 20,
//                       ),
//
//                     bannerTypeField,
//                     SizedBox(
//                       height: 10,
//                     ),
//                     categoryField,
//                     SizedBox(
//                       height: 20,
//                     ),
//                     submitButon,
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Widget _buildAboutDialog(BuildContext context) {
//   return new AlertDialog(
//     // title: const Text('About Pop up'),
//     content: new Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         _buildAboutText(),
//         _buildLogoAttribution(),
//       ],
//     ),
//     // actions: <Widget>[
//     //   new FlatButton(
//     //     onPressed: () {
//     //       Navigator.of(context).pop();
//     //     },
//     //     textColor: Theme.of(context).primaryColor,
//     //     child: const Text('Okay, got it!'),
//     //   ),
//     // ],
//   );
// }
//
// Widget _buildAboutText() {
//   var file;
//   return new Padding(
//     padding: const EdgeInsets.only(top: 16.0),
//     child: new Row(
//       children: <Widget>[
//         file != null
//             ? Container(
//           height: 160.0,
//           width: 160.0,
//           decoration: BoxDecoration(
//             color: const Color(0xff7c94b6),
//             image: DecorationImage(
//               image: ExactAssetImage(file.path),
//               fit: BoxFit.cover,
//             ),
//             border: Border.all(color: Colors.red, width: 5.0),
//             borderRadius:
//             BorderRadius.all(const Radius.circular(20.0)),
//           ),
//         )
//             : SizedBox(
//           width: 0.0,
//         ),
//         // SizedBox(
//         //   height: 100.0,
//         // ),
//         // file != null
//         //     ? RaisedButton(
//         //   child: Text("Upload Image"),
//         //   onPressed: () async {
//         //     var res = await uploadImage(file.path);
//         //     setState(() {
//         //       print(res);
//         //     });
//         //   },
//         // )
//         //     : SizedBox(
//         //   width: 50.0,
//         // ),
//
//         Row(
//           children: [
//             IconButton(icon: Icon(Icons.add_a_photo),iconSize:30,color: Colors.green,),
//             file == null
//                 ? RaisedButton(
//               child: Text("Photos",style: TextStyle(fontSize: 16),),
//               color: Colors.white,
//               elevation: 0,
//               onPressed: () async {
//                 file = await ImagePicker.pickImage(
//                     source: ImageSource.gallery);
//                 if (file != null) {
//                   file = file;
//
//                   setState(() {});
//                 }
//               }
//             )
//                 : SizedBox(
//               width: 0.0,
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }
//
// void setState(Null Function() param0) {
// }
//
// Widget _buildLogoAttribution() {
//   var file;
//   return new Padding(
//     padding: const EdgeInsets.only(top: 16.0),
//     child: new Row(
//       children: <Widget>[
//         file != null
//             ? Container(
//           height: 160.0,
//           width: 160.0,
//           decoration: BoxDecoration(
//             color: const Color(0xff7c94b6),
//             image: DecorationImage(
//               image: ExactAssetImage(file.path),
//               fit: BoxFit.cover,
//             ),
//             border: Border.all(color: Colors.red, width: 5.0),
//             borderRadius:
//             BorderRadius.all(const Radius.circular(20.0)),
//           ),
//         )
//             : SizedBox(
//           width: 0.0,
//         ),
//         // SizedBox(
//         //   height: 100.0,
//         // ),
//         // file != null
//         //     ? RaisedButton(
//         //   child: Text("Upload Image"),
//         //   onPressed: () async {
//         //     var res = await uploadImage(file.path);
//         //     setState(() {
//         //       print(res);
//         //     });
//         //   },
//         // )
//         //     : SizedBox(
//         //   width: 50.0,
//         // ),
//         Row(
//           children: [
//             IconButton(icon: Icon(Icons.video_collection_rounded  ),iconSize:30,color: Colors.green,),
//             file == null
//                 ? RaisedButton(
//               child: Text("Videos",style: TextStyle(fontSize: 16),),
//               color: Colors.white,
//               elevation: 0,
//               onPressed: ()  async {
//             print('Picker is Called');
//               File img = await ImagePicker.pickImage(source: ImageSource.gallery);
//            if (img != null) {
//            var image = img;
//               setState(() {});
//              }
//                   }
//               )
//                 : SizedBox(
//               width: 0.0,
//             ),
//           ],
//         )
//
//       ],
//     ),
//   );
// }
// class CameraConnect extends StatefulWidget {
//   @override
//   _CameraConnectState createState() => _CameraConnectState();
// }
//
// class _CameraConnectState extends State<CameraConnect> {
//   File image;
//
//   //connect camera
//   cameraConnect() async {
//     print('Picker is Called');
//     File img = await ImagePicker.pickImage(source: ImageSource.gallery);
//     if (img != null) {
//       image = img;
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Connect'),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Container(
//           child: image == null ? Text('No Image Showing') : Image.file(image),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.green,
//         child: Icon(Icons.add_a_photo),
//         onPressed: cameraConnect,
//       ),
//     );
//   }
// }
//
