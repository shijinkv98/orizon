import 'dart:ui';

import 'package:flutter/material.dart';

const SUCCESS_MESSAGE = "You will be contacted by us very soon.";
const APP_TAG = "DRIVER_APP";


// Api related
const String BASE_URL = "http://xshop.alisonsdemo.tk/";
const Color colorPrimary = Color(0xFF008872);
const Color gradientEnd = Color(0xFF008872);
const Color primaryTextColor = Color(0xFF008872);
const Color primaryIconColor = Color(0xFF008872);
const double register_icon_size=16.0;
const double field_text_size=10.0;
const Color textColor = Color(0xFF616161);
const Color textColorSecondary = Color(0xFF999999);
const APIKeys = "AIzaSyC6FXxQ6oMlmp8e-uQz2sIth9wJz0c2Od8";

const String productThumbUrl = '${BASE_URL}images/product/thumbnail/';
const padding = 10.0;
const contryCode = 91;
String deviceToken = "";
String deviceId = "";
String currency = "QAR";

// public static final String PRODUCT_URL = MAIN_URL + "images/product/";
// public static final String BANNER_URL = MAIN_URL + "images/banner/";

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
Widget enableData(){
  return
    Container(
    child: Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    IconButton(icon: new Image.asset('assets/icons/nosignal.png'),iconSize: 50,
    ),
        Text("Check Internet Connectivity",style: TextStyle(color: colorPrimary,fontSize: 20),),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text("Swipe Down to Refresh the Screen",style: TextStyle(color:Colors.grey[500],fontSize: 10),),
        ),
      ],
    )),
  );
}

Widget errorScreen(String errorTitle) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(errorTitle),
          )
        ],
      ),
    );
Widget progressBar = InkWell(
  child: SafeArea(
    child: Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
    ),
  ),
);
