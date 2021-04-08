// import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/SingupResponse.dart';
import 'package:vendor_app/notifiers/register_notifier.dart'
    show CheckBoxNotifier;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  CheckBoxNotifier _checkBoxNotifier;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    String shopName;
    _checkBoxNotifier = Provider.of<CheckBoxNotifier>(context, listen: false);
    final shopNameField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        shopName = value;
      },
      style: style,
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
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Shop name",
          labelText: 'Shop name',
          suffixIcon: Icon(
            Icons.person_outline,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );

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
          labelText: 'Email',
          suffixIcon: Icon(
            Icons.alternate_email,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );

    String phoneNo;
    final phoneField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        phoneNo = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Phone Number",
          labelText: 'Phone Number',
          prefixText: '+974 ',prefixStyle:TextStyle(color: Colors.grey),
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
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            if (!_checkBoxNotifier.isChecked) {
              ApiCall()
                  .showToast('Please Accept Terms of Use and Privacy Policy');
            } else {
              Map body = {
                // name,email,phone_number,password
                'name': shopName.trim(),
                'email': email.trim(),
                'password': password.trim(),
                'phone_number': phoneNo,
                'phone_country_code': '974',
                // 'device_token': deviceToken,
                // 'device_id': deviceId,
                // 'device_platform': Platform.isIOS ? '2' : '1',
              };

              FocusScope.of(context).requestFocus(FocusNode());
              var response = await ApiCall()
                  .execute<SignupResponse, Null>("vendorregistration", body);

              if (response?.vendorData != null) {
                // Navigator.of(context)
                //     .pushReplacementNamed('vendorDetails', arguments: '');
                Navigator.of(context)
                    .pushNamed('otp', arguments: response.vendorData);
              }
            }
          }
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
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
                        "Create your Account",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    shopNameField,
                    SizedBox(
                      height: 10,
                    ),
                    emailField,
                    SizedBox(
                      height: 10,
                    ),
                    phoneField,
                    SizedBox(
                      height: 10,
                    ),
                    passwordField,
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Consumer<CheckBoxNotifier>(
                            builder: (context, value, child) {
                              return Checkbox(
                                value: value.isChecked,
                                activeColor: colorPrimary,
                                checkColor: Colors.white,
                                materialTapTargetSize: null,
                                onChanged: (bool value2) {
                                  value.isChecked = value2;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "I Accept All The",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Terms of Use',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF265c7e),
                                    )),
                                TextSpan(
                                  text: ' and',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                TextSpan(
                                    text: ' Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF265c7e),
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    loginButon,
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' Sign in',
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                },
                              style:
                                  TextStyle(color: colorPrimary, fontSize: 15))
                        ]))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: (){
                    FlutterOpenWhatsapp.sendSingleMessage("+97470920545", "Hello");
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
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('SELLER SUPPORT CENTRE',style: TextStyle(color: Colors.white,fontSize: 9,letterSpacing: 1),),
                                  Text('+974 7092 0545',style: TextStyle(color: Colors.white,fontSize: 15,letterSpacing: 1.5,fontWeight: FontWeight.bold),),
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
}
