import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';

import 'home/messaging_widget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      ApiCall().getUserToken().then((token) => {
            if (token != null && token.trim().isNotEmpty)
              {Navigator.of(context).pushReplacementNamed("home")}
            else
              {Navigator.of(context).pushReplacementNamed("login")}
          });

      // Navigator.of(context)
      //     .pushReplacementNamed("mapPlacePicker", arguments: null);
    });
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/icons/splashnew.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
           // MessagingWidget(),
        ],
      ),
    );
  }
}
