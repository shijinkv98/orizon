// import 'dart:convert';
import 'dart:convert' show jsonEncode;
import 'dart:io' show Platform;

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/SingupResponse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendor_app/screens/home/time.dart';
import 'package:vendor_app/screens/register/add_address.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  PickResult selectedPlace;

}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  bool _isObscure = true;
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  BuildContext mContext;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }


  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    GetConnect();
    super.initState();
 // calls getconnect method to check which type if connection it
  }
  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {

      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {

      iswificonnected = true;
      setState(() async {
        wifiBSSID = await (Connectivity().getWifiBSSID());
        wifiIP = await (Connectivity().getWifiIP());
        wifiName = await (Connectivity().getWifiName());
      });

    }
  }
  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text(
        "You are not Connected to Internet",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
  Center ShowWifi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              " Your are connected to ${iswificonnected ? "WIFI" : "MOBILE DATA"}"),
          Text(iswificonnected ? "$wifiBSSID" : "Not Wifi"),
          Text("$wifiIP"),
          Text("$wifiName")
        ],
      ),
    );
  }
  Center ShowMobile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Container(
        color: Colors.white,
      child: Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color:Colors.white,
            child: IconButton(icon: new Image.asset('assets/icons/nosignal.png'),iconSize: 50,
            ),
          ),
          Text("Check Internet Connectivity",style: TextStyle(color: colorPrimary,fontSize: 20),),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text("Swipe Down to Refresh the Screen",style: TextStyle(color:Colors.grey[500],fontSize: 10),),
          ),
        ],
      )),
    )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TextEditingController emailController = new TextEditingController();
    String email;
    final emailField = TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        email = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
          // } else if (value.trim().length != 10) {
          //   return 'Invalid Mobile number';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Phone Number",
        labelText: 'Phone Number',
        prefixText: '+974 ',
        prefixStyle: TextStyle(color: Colors.grey),
        suffixIcon: InkWell(
          onTap: (){

          },
            //
            //     //     PlacePicker(
            //     //   apiKey: APIKeys, // Put YOUR OWN KEY here.
            //     //     onPlacePicked: (result) {
            //     //
            //     //       print(result.name);
            //     //       Navigator.of(context).pop();
            //     //     },
            //     //   initialPosition: LoginScreen.kInitialPosition,
            //     //   // enableMyLocationButton: true,
            //     //   //   enableMapTypeButton: true,
            //     //   useCurrentLocation: true,
            //     //     selectedPlaceWidgetBuilder: ( _, selectedPlace, state, isSearchBarFocused) {
            //     //       return isSearchBarFocused? Container():
            //     //       FloatingCard(
            //     //         color: Colors.white,
            //     //         bottomPosition: MediaQuery.of(context).size.height * 0.5,
            //     //         leftPosition: MediaQuery.of(context).size.width * 0.05,
            //     //         width: MediaQuery.of(context).size.width * 0.9,
            //     //         height: 100,
            //     //         borderRadius: BorderRadius.circular(10.0),
            //     //         child:
            //     //         state != SearchingState.Searching ?
            //     //         Center(child:
            //     //         CircularProgressIndicator()) :
            //     //         // ignore: deprecated_member_use
            //     //         RaisedButton(
            //     //           color:Colors.white,
            //     //           child: Column(
            //     //             children: [
            //     //               Padding(
            //     //                 padding: const EdgeInsets.only(top: 10),
            //     //                 child: Container(
            //     //                     width: double.infinity,
            //     //                     child: Center(child: Text('selectedPlace.name'))),
            //     //               ),
            //     //               Padding(
            //     //                 padding: const EdgeInsets.only(top: 10),
            //     //                 child: Container(
            //     //                   height: 40,
            //     //                   width: 150,
            //     //                   color: colorPrimary,
            //     //                   child: Center(child: Text('Click Here',style: TextStyle(color: Colors.white),)),
            //     //                 ),
            //     //               )
            //     //             ],
            //     //           ),
            //     //           onPressed: () { ApiCall().showToast('message');print("do something with [selectedPlace] data"); },),
            //     //       );
            //     //     },
            //     //
            //     // ),
            //   ),
            // );
          child: Icon(
            Icons.local_phone_outlined,
            color: primaryIconColor,
          ),
        ),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    // final TextEditingController passwordController =
    //     new TextEditingController();
    // PlacePicker(apiKey: 'AIzaSyC6FXxQ6oMlmp8e-uQz2sIth9wJz0c2Od8',
    //   selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
    //     return isSearchBarFocused? Container():
    //     FloatingCard(
    //       color: Colors.red,
    //       bottomPosition: MediaQuery.of(context).size.height * 0.5,
    //       leftPosition: MediaQuery.of(context).size.width * 0.05,
    //       width: MediaQuery.of(context).size.width * 0.9,
    //       borderRadius: BorderRadius.circular(12.0),
    //       child: state == SearchingState.Searching ?
    //       Center(child:
    //       CircularProgressIndicator()) :
    //       // ignore: deprecated_member_use
    //       RaisedButton(
    //         color:Colors.yellow,
    //         child: Text('Select Here'),
    //         onPressed: () { print("do something with [selectedPlace] data"); },),
    //     );
    //   },
    // );

    String password;
    final passwordField = TextFormField(
      obscureText: _isObscure,
      // controller: passwordController,
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        password = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Password",
        labelText: "Password",
        suffixIcon:
        InkWell(
          onTap: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          child: Icon(
            _isObscure ? Icons.lock_outline : Icons.lock_open_outlined,
            color: primaryIconColor,
          ),
        ),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: colorPrimary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed('/home');
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            Map body = {
              // email_phone,password
              'email_phone': email.trim(),
              'password': password.trim(),
              'device_token': deviceToken,
              'device_id': deviceId,
              'device_platform': Platform.isIOS ? '2' : '1',
            };
            FocusScope.of(context).requestFocus(FocusNode());
            // _loginLoadingNotifier.isLoading = true;
            SignupResponse value = await ApiCall()
                .execute<SignupResponse, Null>("vendorlogin", body);
            if (value != null &&
                value.vendorData != null &&
                value.vendorData.token != null) {
              await ApiCall().saveUser(jsonEncode(value.vendorData.toJson()));
              Navigator.of(context).pushReplacementNamed('home');
            }
            // _loginLoadingNotifier.isLoading = false;
          }
        },
        child: Text("Sign in",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
Widget getContent(){
  return Container(
    child:       SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: colorPrimary,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 80),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(65.0),
                    topRight: Radius.circular(65.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Sign in to your Account",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  emailField,
                  SizedBox(
                    height: 10,
                  ),
                  passwordField,
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ForgotPasswordScreen('')));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  loginButon,
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Sign up',
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed('signup');
                                  },
                                style:
                                TextStyle(color: colorPrimary, fontSize: 15))
                          ])),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    // add the [https]
                    return _launch(
                        "https://wa.me/${'+97470920545'}/?text=${Uri.parse('Hello')}");
                    // "https://wa.me/${'+97470920545'}/?text=${Uri.parse('Hello')}"; // new line
                  } else {
                    // add the [https]
                    return _launch(
                        "https://api.whatsapp.com/send?phone=${'+97470920545'}=${Uri.parse('Hello')}"); // new line
                  }
                  // FlutterOpenWhatsapp.sendSingleMessage("+97470920545", "Hello");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 210,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF25d366),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image(
                            image: AssetImage('assets/icons/whatsappl.png'),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          height: 50,
                          width: 155,
                          decoration: BoxDecoration(
                            color: Color(0xFF25d366),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SELLER SUPPORT CENTRE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  '+974 7092 0545',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        child: getContent(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
      ),

    );
  }
}
