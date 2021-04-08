import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/notifiers/product_notifier.dart';
import 'package:vendor_app/screens/home/Maps.dart';
import 'package:vendor_app/screens/home/ad_manager.dart';
import 'package:vendor_app/screens/home/popup.dart';
import 'package:vendor_app/screens/home/popup_content.dart';
import 'package:vendor_app/screens/register/login_screen.dart';
import '../../helpers/constants.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

// const String uploadURL = "http://xshop.alisonsdemo.tk/api//update-logo";

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool circular = true;
  File _image;
  File _image2;
  BuildContext mContext;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isEnabled = true;
  FocusNode focusNode = FocusNode();
  enableButton() {
    setState(() {
      isEnabled = true;
    });
  } // /NetworkHandler  networkHandler = NetworkHandler();

  PickedFile _imageFile;
  PickedFile _imageFile2;
  final String uploadUrl = 'http://xshop.alisonsdemo.tk/api/update-logo';
  final String uploadUrl2 = 'http://xshop.alisonsdemo.tk/api/update-banner';
  final String uploadUrl3 = 'http://xshop.alisonsdemo.tk/api/update-profile ';
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();
  String whatsapp = "";
  String facebook = "";
  String instagram = "";
  String youtube = "";
  String website = "";
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  ImageAddedNotifier _imageAddedNotifier;

  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('logo', filepath));
    ApiCall().showToast('Logo Updated Successfully');
    request.fields['id'] = userId;
    request.fields['token'] = userToken;
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<String> uploadImage2(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('banner', filepath));
    ApiCall().showToast('Banner Updated Successfully');
    request.fields['id'] = userId;
    request.fields['token'] = userToken;
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
        uploadImage(_image.path, uploadUrl);
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  Future<void> retriveLostData2() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile2 = response.file;
        uploadImage2(_image2.path, uploadUrl);
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  void _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage(_image.path, uploadUrl);
      });
    }
  }

  void _getFromCamera2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage2(pickedFile.path);
  }

  _cropImage2(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image2 = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage2(_image2.path, uploadUrl2);
      });
    }

    // _imgFromCamera() async {
    //   // ignore: deprecated_member_use_from_same_package
    //   File image = await ImagePicker.pickImage(
    //       source: ImageSource.camera, imageQuality: 50);
    //
    //   setState(() {
    //     _image = image;
    //     uploadImage(_image.path, uploadUrl);
    //   });
    // }

    // _imgFromCamera2() async {
    // ignore: deprecated_member_use_from_same_package
    // File image2 = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50);
    //
    // setState(() {
    //   _image2 = image2;
    //   uploadImage2(_image2.path, uploadUrl2);
    // });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Position _location = new Position(latitude: 0.0, longitude: 0.0);
  // void _displayCurrentLocation() async {
  //   final location = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   setState(() {
  //     _location = location;
  //   });
  // }

  void _showPicker2(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery2();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera2();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage3(pickedFile.path);
  }

  _cropImage3(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage(_image.path, uploadUrl);
      });
    }
  }

  void _getFromGallery2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage4(pickedFile.path);
  }

  _cropImage4(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image2 = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage2(_image2.path, uploadUrl2);
      });
    }

    // _imgFromGallery() async {
    //   // ignore: deprecated_member_use_from_same_package
    //   File image = await ImagePicker.pickImage(
    //       source: ImageSource.gallery, imageQuality: 50);
    //
    //   setState(() {
    //     _image = image;
    //     uploadImage(_image.path, uploadUrl);
    //   });
    // }
    //
    // _imgFromGallery2() async {
    //   // ignore: deprecated_member_use_from_same_package
    //   File image2 = await ImagePicker.pickImage(
    //       source: ImageSource.gallery, imageQuality: 50);
    //
    //   setState(() {
    //     _image2 = image2;
    //     uploadImage2(_image2.path, uploadUrl2);
    //   });
    // }
  }

  @override
  void initState() {
    // Provider.of<GenerateMaps>(context,listen: false).getCurrentLocation();
    super.initState();
    fetchData();
  }

  void fetchData() async {}
  final double _paddingTop = 10;

  final double _paddingStart = 10;

  final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 3.0,
      ),
    ],
  );

  void _handleMoreOptionClick(String value) {
    switch (value) {
      case 'logout':
        {
          ApiCall().saveUser('').whenComplete(() => Navigator.of(context).pushReplacementNamed('login'));
        }
        break;
      case 'logo':
        {
          _image;
        }
        break;
      default:
        {}
        break;
    }
  }

  //   }
  // }
  final String apiURL = 'http://xshop.alisonsdemo.tk/api/profile';
  Future<String> getUserToken() async {
    String token;
    var user = await ApiCall().getUser();
    if (user != null && user.token != null && user.token.trim().isNotEmpty) {
      token = user.token;
    }
    return token;
  }

  Future<String> getUserId() async {
    String id;
    var user = await ApiCall().getUser();
    if (user != null && user.id != null && user.id.trim().isNotEmpty) {
      id = user.id;
    }
    return id;
  }

  String presetText;
  String userId = "", userToken = "";
  String whatsapp_num = "";
  void _onPressed() {
    setState(() {
      presetText = 'updated text';
    });
  }

  Future<GetUsers> fetchJSONData() async {
    var user = await getUser();
    Data data = Data(user);
    userId = data.user.id;
    userToken = data.user.token;
    var url = apiURL + "?id=" + userId.toString() + "&token=" + userToken;
    var jsonResponse = await http.get(url);

    if (jsonResponse.statusCode == 200) {
      Map<String, dynamic> items = jsonDecode(jsonResponse.body);
      String success = items['success'].toString();
      if (success == "2") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      }
      String joined = items['joined'];
      String storename = items['storename'];
      String email = items['email'];
      String orders = items['orders'].toString();
      String message = items['message'].toString();
      String phone_number = items['phone_number'];
      String mobile_verified = items['mobile_verified'];
      String email_verified = items['email_verified'];
      String latitude = items['latitude'];
      String longtitude = items['longtitude'];
      String country = items['country'];
      String location = items['location'];
      String store_verified_status = items['store_verified_status'].toString();
      var venderSocialMedia = items['vendor_social_media'];
      var venderDeliveryInfo = items['vendor_settings'];

      //   var validity=item['validity'];
      GetUsers userData = new GetUsers(
          success: success,
          joined: joined,
          orders: orders,
          storename: storename,
          phone_number: phone_number,
          mobile_verified: mobile_verified,
          email: email,
          email_verified: email_verified,
          latitude: latitude,
          longtitude: longtitude,
          country: country,
          location: location,
          store_verified_status: store_verified_status,
          message: message);

      for (int i = 0; i < venderSocialMedia.length; i++) {
        var object = venderSocialMedia[i];
        userData.setVenderSocialMedia(object);
      }
      for (int i = 0; i < venderDeliveryInfo.length; i++) {
        var object = venderDeliveryInfo[i];
        userData.setVederDeliveryInfo(object);
      }
      userData.setImage(items['logo']);
      userData.setBanner(items['banner']);
      return userData;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  ProfileData profileData;
  Future<GetUsers> getProfile() async {
    var user = await fetchJSONData();
    profileData = ProfileData(user);
    _textController.text = profileData.user.getLink(WHATSAPP);
    _textController1.text = profileData.user.getLink(FACEBOOK);
    _textController2.text = profileData.user.getLink(INSTAGRAM);
    _textController3.text = profileData.user.getLink(YOUTUBE);
    _textController4.text = profileData.user.getLink(WEBSITE);
    _textController5.text = profileData.user.getValue(DELIVERYRADIUS);
    _textController6.text = profileData.user.getValue(DELIVERYCHARGE);
    _textController7.text = profileData.user.getValue(DELIVERYAMOUNT);
    _textController8.text = profileData.user.getValue(STORETIME);
    _textController9.text = profileData.user.phone_number;
    _textController10.text = profileData.user.email;
    _textController11.text = profileData.user.location;
    return null;
  }

  TextEditingController _textController;
  TextEditingController _textController1;
  TextEditingController _textController2;
  TextEditingController _textController3;
  TextEditingController _textController4;
  TextEditingController _textController5;
  TextEditingController _textController6;
  TextEditingController _textController7;
  TextEditingController _textController8;
  TextEditingController _textController9;
  TextEditingController _textController10;
  TextEditingController _textController11;
  @override
  Widget build(BuildContext context) {
    mContext = context;
    ApiCall().execute('profile', null, isGet: true);
    getProfile();
    if (profileData == null) {
      GetUsers user = new GetUsers(
          success: "1",
          joined: "",
          storename: "",
          orders: "",
          phone_number: "",
          mobile_verified: "",
          email_verified: "",
          latitude: "",
          longtitude: "",
          country: "",
          location: "",
          store_verified_status: "",
          message: "");
      profileData = new ProfileData(user);
    }
    // UserData userData=getUser() as UserData;
    final _padding = EdgeInsets.fromLTRB(
        _paddingStart, _paddingTop, _paddingStart, _paddingTop);

    _textController = new TextEditingController();
    _textController1 = new TextEditingController();
    _textController2 = new TextEditingController();
    _textController3 = new TextEditingController();
    _textController4 = new TextEditingController();
    _textController5 = new TextEditingController();
    _textController6 = new TextEditingController();
    _textController7 = new TextEditingController();
    _textController8 = new TextEditingController();
    _textController9 = new TextEditingController();
    _textController10 = new TextEditingController();
    _textController11 = new TextEditingController();
    bool _enabled = false;

    String whatsapp = "";

    final whatsappField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController,
      obscureText: false,
      onSaved: (value) {
        whatsapp = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "with country code",
        labelText: "Whatsapp Number",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/whatsapp.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String facebook;
    final facebookField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController1,
      obscureText: false,
      onSaved: (value) {
        facebook = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Facebook Link",
        labelText: "Facebook",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/facebook.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String instagram;
    final instagramField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController2,
      obscureText: false,
      onSaved: (value) {
        instagram = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Instagram Link",
        labelText: "Instagram",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/instagram.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String youtube;
    final youtubeFiled = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController3,
      obscureText: false,
      onSaved: (value) {
        youtube = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Youtube Link",
        labelText: "Youtube",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/youtube.png',
            width: 5,
            height: 5,
          ),
        ),
      ),
    );
    String website;
    final websiteField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController4,
      obscureText: false,
      onSaved: (value) {
        website = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Add Website URL",
        labelText: "Website URL",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/globe.png',
            width: 5,
            height: 5,
          ),
        ),
      ),
    );

    String deliveryRadius;
    final deliveryRadiusField = TextFormField(
      controller: _textController5,
      obscureText: false,
      onSaved: (value) {
        deliveryRadius = value;
        // _guaranteePeriod = value;
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onTap: () {},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Free delivery Radius",
        labelText: "Free delivery Radius",
      ),
    );

    String deliveryCharge;
    final deliveryChargeField = TextFormField(
      controller: _textController6,
      obscureText: false,
      onSaved: (value) {
        deliveryCharge = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Min Delivery charge",
        labelText: "Min Delivery charge",
      ),
    );
    String deliveryAmount;
    final deliveryAmountField = TextFormField(
      controller: _textController7,
      obscureText: false,
      onSaved: (value) {
        deliveryAmount = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Free Delivery Amount",
        labelText: "Free Delivery Amount",
      ),
    );
    String storeTime;
    final storeTImeField = TextFormField(
      controller: _textController8,
      obscureText: false,
      enabled: false,
      onSaved: (value) {
        storeTime = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Store Time",
        labelText: "Store Time",
      ),
      // onTap: () {
      //
      // }
      // async {
      //   showTimePicker(
      //       initialTime: TimeOfDay.now(),
      //       context: context,
      //       builder: (context, child) {
      //         return _timePickerTheme(context, child);
      //       },
      //       helpText: 'Opening Time')
      //       .then((value) => showTimePicker(
      //       initialTime: TimeOfDay.now(),
      //       context: context,
      //       builder: (context, child) {
      //         return _timePickerTheme(context, child);
      //       },
      //       helpText: 'Closing Time'));
      // },
    );

    String phoneNumber;

    final phoneNumberField = TextFormField(
      enabled: false,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.left,
      initialValue: presetText,
      controller: _textController9,
      obscureText: false,
      onSaved: (value) {
        phoneNumber = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Phone Number",
      ),
    );

    String email;

    final emailField = TextFormField(
      enabled: false,
      // enabled: isEnabled,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.left,
      initialValue: presetText,
      controller: _textController10,
      obscureText: false,

      onSaved: (value) {
        email = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon:
            ImageIcon(AssetImage('assets/icons/edit.png'), color: colorPrimary),
        hintText: "Email",
      ),
    );

    String location;
    final locationField = TextFormField(
      enabled: false,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.left,
      initialValue: presetText,
      controller: _textController11,
      obscureText: false,
      onSaved: (value) {
        location = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        // hintText: finalAddress
      ),
    );
    Widget getTime() {
      return InkWell();
    }

    Widget getContent() {
      final halfMediaWidth = MediaQuery.of(context).size.width / 2;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker2(context);
                    },
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(profileData.user.getBanner()),
                              fit: BoxFit.cover),
                        ),
                        child: _image2 != null
                            ? ClipRRect(
                                // borderRadius:
                                // BorderRadius.circular(55),
                                child: Image.file(
                                  _image2,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(0)),
                                width: 115,
                                height: 115,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Expanded(
                          child: Text(
                        'Account',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          _handleMoreOptionClick(value);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: colorPrimary,
                        ),
                        itemBuilder: (BuildContext context) {
                          var list = List<PopupMenuEntry<String>>();
                          list.add(
                            PopupMenuItem<String>(
                              height: 15,
                              child: Text(
                                "Logout",
                                // style: TextStyle(color: TEXT_BLACK),
                              ),
                              value: 'logout',
                            ),
                          );
                          return list;
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 160,
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    NetworkImage(profileData.user.getImage()),
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Image.file(
                                          _image,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        width: 115,
                                        height: 115,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // ClipOval(
                      //   child: FadeInImage.assetNetwork(
                      //     ,placeholder: 'assets/images/no_image.png'
                      //     image: "",
                      //     width: 80,
                      //     fit: BoxFit.cover,
                      //     height: 80,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(profileData.user.storename)
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Color(0xFFebebeb),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Joined',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(profileData.user.joined),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Color(0xFFebebeb),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Orders',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(profileData.user.orders),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Color(0xFFebebeb),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Profile Information',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.system_update_tv,
                          size: 20,
                        ),
                        onPressed: () async {
                          if (_formKey4.currentState.validate()) {
                            _formKey4.currentState.save();
                            // _formKey3.currentState.save();
                            // } else {
                            Map body = {
                              'email': _textController10.text,
                              // 'phone_number':  _textController9.text,
                              // 'country': location.trim(),
                              // 'id': userId,
                              // 'token': userToken
                            };
                            FocusScope.of(context).requestFocus(FocusNode());
                            ApiCall()
                                .execute("update-profile", body,
                                    multipartRequest: null)
                                .then((value) {
                              ApiCall().showToast(
                                  'Profile Information Updated successfully');
                              setState(() {});
                            });
                          }
                        },
                      ),
                      Text('Update'),
                    ],
                    // FocusScope.of(context)
                    //     .requestFocus(FocusNode());
                    // var response = await ApiCall().execute<EditProfile, Null>("update-profile", body);
                    // ApiCall().showToast('Profile Information Updated successfully');
                    // setState(() {});
                    //
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 2),
              padding: EdgeInsets.all(0),
              decoration: _boxDecoration,
              child: new Form(
                  key: _formKey3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 10),
                                width: halfMediaWidth,
                                child: phoneNumberField,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(
                                        profileData.user.mobile_verified,
                                        style: TextStyle(
                                            color: primaryTextColor))),
                              )
                            ],
                          )),
                    ],
                  )),
            ),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     phoneNumberField
            //
            //     // TextFormField(
            //     //   controller:_textController9,
            //     //   obscureText: false,
            //     //   decoration: InputDecoration(
            //     //     hintText: "Enter a message",
            //
            //        //   suffixIcon: IconButton(
            //       //     onPressed: () => _textController9.clear(),
            //       //     icon: Icon(Icons.clear),
            //       //   ),
            //       // ),
            //     ]
            //     ),

            // SizedBox(
            //   width: 10,
            // ),
            // Text(
            //   profileData.user.mobile_verified,
            //   style: TextStyle(color: primaryTextColor),
            // ),
            // Expanded(child: SizedBox()),
            //     InkWell(
            //       onTap: () {},
            //       child: Image.asset(
            //         'assets/icons/edit.png',
            //         height: 20,
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //   ],
            // )),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              decoration: _boxDecoration,
              child: new Form(
                  key: _formKey4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Container(
                            // alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 10),
                            // width: MediaQuery.of(context).size.width /1.5,
                            child: InkWell(
                                onTap: () {
                                  showPopup(
                                      context, _popupBody(), 'Edit Email Id');
                                },
                                child: emailField),
                          )),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(0),
                decoration: _boxDecoration,
                child: new Form(
                    key: _formKey5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10),
                                  width: halfMediaWidth,
                                  child: locationField,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(Icons.my_location))
                                    // Text(
                                    //     finalAddress,
                                    //     style: TextStyle(
                                    //         color: primaryTextColor))),
                                    )
                              ],
                            )),
                      ],
                    )),
              ),
              // Container(
              //     width: double.infinity,
              //     margin: const EdgeInsets.only(top: 8),
              //     padding: EdgeInsets.fromLTRB(_paddingStart, _paddingTop,
              //         _paddingStart, _paddingTop),
              //     decoration: _boxDecoration,
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Expanded(child: Text("${_location.latitude}, ${_location.longitude}")),
              //         Icon(
              //           Icons.my_location,
              //
              //           size: 20,
              //         ),
              //       ],
              //     )),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: EdgeInsets.fromLTRB(
                    _paddingStart, _paddingTop, _paddingStart, _paddingTop),
                decoration: _boxDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Store verified status'),
                    Expanded(
                        child: SizedBox(
                      height: 20,
                    )),
                    Text(
                      profileData.user.store_verified_status,
                      style: TextStyle(color: primaryTextColor),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: _padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Social Media',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.system_update_tv,
                          color: colorPrimary,
                          size: 20,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // } else {
                            Map body = {
                              // name,email,phone_number,password
                              'whatsapp': "https://wa.me/" + whatsapp.trim(),
                              'facebook': facebook.trim(),
                              'instagram': instagram.trim(),
                              'youtube': youtube.trim(),
                              'website_url': website.trim(),
                              'id': userId,
                              'token': userToken
                            };

                            FocusScope.of(context).requestFocus(FocusNode());
                            ApiCall()
                                .execute("update-social-media", body,
                                    multipartRequest: null)
                                .then((value) {
                              ApiCall().showToast(
                                  'Social Media Updated successfully');
                              setState(() {});
                            });
                          }
                        },
                      ),
                      Text('Update'),
                    ],
                  ),
                ],
              ),
            ),
            new Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: whatsappField,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: facebookField,
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: instagramField,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: youtubeFiled,
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: websiteField,
                    )
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: _padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Delivery Information',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.system_update_tv,
                          color: colorPrimary,
                          size: 20,
                        ),
                        onPressed: () async {
                          if (_formKey2.currentState.validate()) {
                            _formKey2.currentState.save();
                            // } else {
                            Map body = {
                              // name,email,phone_number,password
                              'free_delivery_radius': deliveryRadius.trim(),
                              'min_delivery_charge': deliveryCharge.trim(),
                              'free_delivery_amount': deliveryAmount.trim(),
                              'store_time': storeTime.trim(),
                              'id': userId,
                              'token': userToken
                            };

                            FocusScope.of(context).requestFocus(FocusNode());

                            ApiCall()
                                .execute("update-delivery-info", body)
                                .then((value) {
                              ApiCall().showToast(
                                  'Delivery Information Updated successfully');
                              setState(() {});
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             super.widget));
                            });

                            // var response = await ApiCall()
                            //     .execute<Delivery, Null>(
                            //         "update-delivery-info", body);
                          }
                        },
                      ),
                      Text('Update'),
                    ],
                  ),
                ],
              ),
            ),
            new Form(
                key: _formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: deliveryRadiusField,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: deliveryChargeField,
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: deliveryAmountField,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: InkWell(
                                  onTap: () {
                                    TimeRangePicker.show(
                                      context: context,
                                      onSubmitted: (TimeRangeValue value) {
                                        print(
                                            "${value.startTime} - ${value.endTime}");
                                        // _textController8 = ("${value.startTime} - ${value.endTime}") as TextEditingController;
                                        _textController8.text =
                                            "${value.startTime.format(context)} - ${value.endTime.format(context)}";
                                      },
                                    );
                                  },
                                  child: storeTImeField),
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   width: double.infinity,
            //   padding: _padding,
            //   child: RaisedButton(
            //     onPressed: () async {
            //       if (_formKey2.currentState.validate()) {
            //         _formKey2.currentState.save();
            //         // } else {
            //         Map body = {
            //           // name,email,phone_number,password
            //           'free_delivery_radius': deliveryRadius.trim(),
            //           'min_delivery_charge': deliveryCharge.trim(),
            //           'free_delivery_amount': deliveryAmount.trim(),
            //           'store_time': storeTime.trim(),
            //           'id': userId,
            //           'token': userToken
            //         };
            //
            //         FocusScope.of(context).requestFocus(FocusNode());
            //         var response = await ApiCall().execute<Delivery, Null>(
            //             "update-delivery-info", body);
            //       }
            //     },
            //     color: colorPrimary,
            //     child: Text('UPDATE'),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Account'),
      //   centerTitle: true,
      //   backgroundColor: colorPrimary,
      // ),
      body: SmartRefresher(
        enablePullDown: true,
        child: FutureBuilder<GetUsers>(
          future: fetchJSONData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getContent();
            } else if (snapshot.hasError) {
              return
                // enableData();
              errorScreen('Error: ${snapshot.error}');
            } else {
              return progressBar;
            }
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
      ),
    );
  }

  Widget _timePickerTheme(BuildContext context, Widget child) => Theme(
      data: Theme.of(context).copyWith(
        timePickerTheme: TimePickerTheme.of(context).copyWith(
          helpTextStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      child: child);

  _showDialog(
      {ValueChanged<String> onValueChanged,
      String hint,
      RegExp regExp,
      TextInputType textInputType = TextInputType.emailAddress}) async {
    final myController = TextEditingController();
    await showDialog<String>(
      builder: (context) => _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(hint),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: myController,
                  keyboardType: textInputType,
                  decoration:
                      new InputDecoration(labelText: hint, hintText: hint),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('SUBMIT'),
                onPressed: () {
                  String value = myController.text?.trim() ?? '';
                  if (value.isEmpty ||
                      (regExp != null && !regExp.hasMatch(value))) {
                    ApiCall().showToast('Please enter a valid $hint');
                  } else {
                    onValueChanged(value);
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      ),
      context: context,
    );
  }

  Widget _popupBody() {
    return Container(
        child: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                TextFormField(
                  enabled: true,
                  // enabled: isEnabled,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.left,
                  initialValue: presetText,
                  controller: _textController10,
                  obscureText: false,

                  // onSaved: (value) {
                  //   email = value;
                  //   // _guaranteePeriod = value;
                  // },
                  // initialValue: _guaranteePeriod,
                  // style: style,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'This field is required';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.alternate_email,
                      color: primaryIconColor,
                    ),
                    hintText: "Email",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 40,
                      width: 70,
                      color: colorPrimary,
                      child: Center(
                          child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 30,
        right: 30,
        bottom: MediaQuery.of(context).size.height * 0.38,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomInset: false,
            body: widget,
          ),
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

Future<UserData> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') == null ? "" : prefs.getString('user');
  if (user == null || user.trim().isEmpty) {
    return null;
  }
  return UserData.fromJson(json.decode(user == null ? "" : user));
}

class Data {
  UserData user;

  Data(this.user);
}

class ProfileData {
  GetUsers user;

  ProfileData(this.user);
}

final String WHATSAPP = "Whatsapp";
final String FACEBOOK = "Facebook";
final String INSTAGRAM = "Instagram";
final String YOUTUBE = "Youtube";
final String WEBSITE = "Website URL";
final String DELIVERYRADIUS = "free_delivery_radius";
final String DELIVERYCHARGE = "min_delivery_charge";
final String DELIVERYAMOUNT = "free_delivery_amount";
final String STORETIME = "store_time";
final String LOGO_URL =
    "http://xshop.alisonsdemo.tk/images/registration/logo/thumbnail/";
// final String LOGO_URL = "http://xshop.alisonsdemo.tk/images/registration/logo/thumbnail/";
final String BANNER_URL =
    "http://xshop.alisonsdemo.tk/images/registration/banner/thumbnail/";

class VenderSocailMedia {
  String name;
  String link;
  VenderSocailMedia({this.name, this.link});
}

class VenderDeliveryInfo {
  String key;
  String value;
  VenderDeliveryInfo({this.key, this.value});
}

class GetUsers {
  String success;
  String joined;
  String storename;
  String orders;
  String message;
  String phone_number;
  String mobile_verified;
  String email;
  String email_verified;
  String latitude;
  String longtitude;
  String country;
  String location;
  String store_verified_status;
  List<VenderSocailMedia> venderSocailMedias = new List();
  List<VenderDeliveryInfo> venderDeliveryInfos = new List();
  String image = "";
  String banner = "";
  GetUsers({
    this.success,
    this.storename,
    this.joined,
    this.orders,
    this.message,
    this.phone_number,
    this.mobile_verified,
    this.email,
    this.email_verified,
    this.latitude,
    this.longtitude,
    this.country,
    this.location,
    this.store_verified_status,
  });
  void setVenderSocialMedia(var vendersocial) {
    String venderName = vendersocial['name'];
    String venderLink = vendersocial['link'];
    VenderSocailMedia vender =
        new VenderSocailMedia(name: venderName, link: venderLink);
    venderSocailMedias.add(vender);
  }

  void setImage(String image) {
    this.image = image;
  }

  String getImage() {
    return LOGO_URL + image;
  }

  void setBanner(String banner) {
    this.banner = banner;
  }

  String getBanner() {
    return BANNER_URL + banner;
  }

  void setVederDeliveryInfo(var venderdelivery) {
    String venderKey = venderdelivery['key'];
    String venderValue = venderdelivery['value'];
    VenderDeliveryInfo vender2 =
        new VenderDeliveryInfo(key: venderKey, value: venderValue);
    venderDeliveryInfos.add(vender2);
  }

  String getLink(String name_) {
    String link = "";
    for (int i = 0; i < venderSocailMedias.length; i++) {
      VenderSocailMedia media = venderSocailMedias[i];
      if (media.name == name_) {
        return media.link;
      }
    }
    return link;
  }

  String getValue(String key_) {
    String value = "";
    for (int i = 0; i < venderDeliveryInfos.length; i++) {
      VenderDeliveryInfo media = venderDeliveryInfos[i];
      if (media.key == key_) {
        return media.value;
      }
    }
    return value;
  }

  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
      success: json['success'],
      joined: json['joined'],
      storename: json['storename'],
      orders: json['orders'],
      message: json['message'],
      phone_number: json['phone_number'],
      mobile_verified: json['mobile_verified'],
      email: json['email'],
      email_verified: json['email_verified'],
      latitude: json['latitude'],
      longtitude: json['longtitude'],
      country: json['country'],
      location: json['location'],
      store_verified_status: json['store_verified_status'],
    );
  }
}

class MyImagePicker extends StatefulWidget {
  MyImagePicker({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

Future<Social> createAlbum(String title) async {
  final http.Response response = await http.post(
    'http://xshop.alisonsdemo.tk/update-social-media',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'whatsapp': " ",
      'facebook': " ",
      'instagram': " ",
      'youtube': " ",
      'website_url': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return Social.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Social {
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String youtube;
  final String website_url;

  Social(
      {this.facebook,
      this.whatsapp,
      this.instagram,
      this.website_url,
      this.youtube});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      facebook: json['facebook'],
      whatsapp: json['whatsapp'],
      instagram: json['instagram'],
      website_url: json['website_url'],
      youtube: json['youtube'],
    );
  }
}

Future<Delivery> createDelivery(String title) async {
  final http.Response response = await http.post(
    'http://xshop.alisonsdemo.tk/update-delivery-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'free_delivery_radius': " ",
      'min_delivery_charge': " ",
      'free_delivery_amount': " ",
      'store_time': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return Delivery.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Delivery {
  final String free_delivery_radius;
  final String min_delivery_charge;
  final String free_delivery_amount;
  final String store_time;

  Delivery({
    this.min_delivery_charge,
    this.free_delivery_radius,
    this.free_delivery_amount,
    this.store_time,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      min_delivery_charge: json['min_delivery_charge'],
      free_delivery_radius: json['free_delivery_radius'],
      free_delivery_amount: json['free_delivery_amount'],
      store_time: json['store_time'],
    );
  }
}

Future<EditProfile> createEditProfile(String title) async {
  final http.Response response = await http.post(
    'http://xshop.alisonsdemo.tk/api/update-profile ',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': " ",
      'phone_number': " ",
      'country': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return EditProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class EditProfile {
  int success;
  String message;
  // List<Reasons> reasons;
  EditProfile.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
  }
}
