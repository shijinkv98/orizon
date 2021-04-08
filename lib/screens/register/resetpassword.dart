import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/screens/register/forgotpassword.dart';
import 'package:vendor_app/screens/register/forgotresponse.dart';
import 'package:vendor_app/screens/register/login_screen%20copy.dart';

import 'login_screen.dart';



class ResetPasswordScreen extends StatefulWidget {
  String code, number;
  ResetPasswordScreen({this.code,this.number, String email});
  @override
  _ResetPasswordScreenState createState() => new _ResetPasswordScreenState(code: code,number: number);
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String code, number;
  _ResetPasswordScreenState({ this.code,this.number}) ;
  bool _isObscure = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    String password="";
    final passwordField = TextFormField(
      cursorColor: colorPrimary,
      obscureText: _isObscure,
      onChanged: (value) {
        password = value;
      },
      initialValue: password,
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
        contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding, 0.0),
        hintText: "Enter New Password", hintStyle: TextStyle(color: textColorSecondary),
        labelText: 'New Password',
        labelStyle: TextStyle(fontSize: field_text_size, color: textColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorPrimary),
        ),


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
    String repassword="";
    final repasswordField = TextFormField(
      cursorColor: colorPrimary,
      obscureText: _isObscure2,
      onChanged: (value) {
        repassword = value;
      },
      initialValue: repassword,
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
        contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding, 0.0),
        hintText: "Confirm Password", hintStyle: TextStyle(color: textColorSecondary),
        labelText: 'Re-enter New Password',
        labelStyle: TextStyle(fontSize: field_text_size, color: textColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorPrimary),
        ),


        suffixIcon:
        InkWell(
          onTap: () {
            setState(() {
              _isObscure2 = !_isObscure2;
            });
          },
          child: Icon(
            _isObscure2 ? Icons.lock_outline : Icons.lock_open_outlined,
            color: primaryIconColor,
          ),
        ),

        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    Widget getButton(BuildContext context,String number,String code) {
      return Padding(
        padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          height: 40,
          child: RaisedButton(
            color: colorPrimary,
            elevation: 0,
            child: Text('Update',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
            onPressed: () async {

              if(password==repassword)
              {
                Map body={
                  "email":number,
                  "phone_country_code":code,
                  "password":password,
                  "code":otp
                };
                FocusScope.of(context).requestFocus(FocusNode());

                var response = await ApiCall()
                    .execute<ForgotResponse, Null>("reset-password", body);

                if (response!= null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                }
              }
              else
              {
                ApiCall().showToast("password not match");
              }
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => Login()));

            },
          ),
        ),
      );
    }
    Widget getForms(){
      return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 5,left: 25,right: 25,bottom: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: passwordField,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: repasswordField
              ),


            ],
          ),
        ),
      );
    }
    Container getPersonalInfo()
    {
      return Container(
        child: Container(width: double.infinity,
          child: Column(

            children: [
              getForms(),


            ],
          ),

        ),
      );
      //return Container(child: Column(children: [Container(child:_listview(products,context,widget))],),);

    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        centerTitle: false,
        automaticallyImplyLeading: true,
        title:  Text('Reset Password',style:TextStyle(fontSize:15,color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                getOtp(),
                getPersonalInfo(),
                getButton(context,number,code)
              ],
            ),
          )),

    );

  }

}
Widget getOtp(){
  return Padding(
   padding: const EdgeInsets.only(top: 5,left: 25,right: 25,bottom: 20),
    child: Container(
      child: otpField,

    ),
  );
}





String otp="";
final    otpField = TextFormField(
  cursorColor: colorPrimary,
  obscureText: false,
  onChanged: (value) {
    otp = value;
  },
  initialValue: otp,
  // style: style,
  validator: (value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    } else {
      return null;
    }
  },
  keyboardType: TextInputType.number,
  maxLength: 6,
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding, 0.0),
    hintText: "Enter Otp", hintStyle: TextStyle(color: textColorSecondary),
    // labelText: 'New Password',
    labelStyle: TextStyle(fontSize: field_text_size, color: textColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[200]),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorPrimary),
    ),


    // prefixIcon: new IconButton(
    //   icon: new Image.asset(
    //     'assets/icons/change_password.png',
    //     width: register_icon_size,
    //     height: register_icon_size,
    //   ),
    //   onPressed: null,
    //   color: colorPrimary,
    // ),

    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
  ),
);


