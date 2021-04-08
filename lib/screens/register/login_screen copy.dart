import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';

class LoginScreenDemo extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
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
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Invalid email';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Email",
          labelText: 'Email*',
          suffixIcon: Icon(
            Icons.local_phone_outlined,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );

    // final TextEditingController passwordController =
    //     new TextEditingController();
    String password;
    final passwordField = TextFormField(
      obscureText: true,
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
        labelText: "Password*",
        suffixIcon: Icon(
          Icons.lock_outline,
          color: primaryIconColor,
        ),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color.fromARGB(255, 163, 148, 103),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed('/home');
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context).pushReplacementNamed('home');
          }
        },
        child: Text("LOGIN",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      // body: Stack(
      //   children: [
      //     Container(
      //       child: Center(
      //         child: SingleChildScrollView(
      //           child: Card(
      //             margin: EdgeInsets.all(12.0),
      //             child: Padding(
      //               padding: const EdgeInsets.all(28.0),
      //               child: Form(
      //                 key: _formKey,
      //                 child: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: <Widget>[
      //                     SizedBox(height: 15.0),
      //                     Image(
      //                       image: AssetImage("assets/images/logo_1.png"),
      //                       height: 40.0,
      //                       fit: BoxFit.contain,
      //                     ),
      //                     SizedBox(height: 15.0),
      //                     emailField,
      //                     SizedBox(height: 25.0),
      //                     passwordField,
      //                     SizedBox(
      //                       height: 35.0,
      //                     ),
      //                     loginButon,
      //                     SizedBox(
      //                       height: 15.0,
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      "Sign in to your Account",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    emailField,
                    SizedBox(
                      height: 10,
                    ),
                    passwordField,
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 45, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        color: colorPrimary,
                        onPressed: () {},
                        textColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                                child: const Text(
                              "Request OTP",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w400),
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' Sign up',
                              style:
                                  TextStyle(color: colorPrimary, fontSize: 18))
                        ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
