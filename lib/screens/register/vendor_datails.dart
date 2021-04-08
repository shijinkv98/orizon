import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/custom/fdottedline.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/helpers/mime_type.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/SingupResponse.dart';
import 'package:vendor_app/notifiers/register_notifier.dart';
import 'package:vendor_app/screens/home/Maps.dart';


class VendorDetailScreen extends StatefulWidget {
  final UserData userData;
  VendorDetailScreen({Key key, @required this.userData}) : super(key: key);
  @override
  _VendorDetailScreenState createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  String _shopType, _productCount, _country, _location;
  final _allowedDocuments = ['docx', 'pdf', 'doc','jpeg','png','jpg'];
  String _physicalStore = 'yes';
  final _countries = [
    'Qatar'
    // , 'India'
  ];
  FileModel _regstraionDoc, _tradeLicenceDoc, _sellerIdDoc;
  DocsAddedNotifier _docsAddedNotifier;
  PhysicalStoreClickNotifier _physicalStoreNotifier;
  TextEditingController _textController100;
  @override
  void initState() {

    super.initState();
    _textController100 = new TextEditingController();
    Provider.of<GenerateMaps>(context,listen: false).getCurrentLocation();
    _docsAddedNotifier = Provider.of<DocsAddedNotifier>(context, listen: false);
    _physicalStoreNotifier =
        Provider.of<PhysicalStoreClickNotifier>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    final _shopTypeField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _shopType = value;
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
        hintText: "Type of shop",
        labelText: 'Type of shop*',
      ),
    );

    final _productCountField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _productCount = value;
      },
      style: style,
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
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "How many products you would like to upload",
        labelText: "How many products you would like to upload",
      ),
    );
    final _countryField = DropdownButtonFormField(
      value: _country,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
        hintStyle: TextStyle(fontSize: 14),
        labelStyle: TextStyle(fontSize: 14),
        hintText: 'Country*',
        labelText: 'Country*',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      isExpanded: true,
      isDense: true,
      onChanged: (String newValue) {
        // setState(() {
        _country = newValue;
        // state.didChange(newValue);
        // });
      },
      items: _countries.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );


    final _locationField = TextFormField(
      controller: _textController100,
      obscureText: false,
      onSaved: (value) {
        _location = value;
      },
      style: style,
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
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        suffixIcon:  IconButton(
          onPressed: (){
        _textController100.text = finalAddress;

        },
          icon: Icon(Icons.my_location),
        ),
        hintText:"Enter Current Location",focusColor: Colors.black,
        labelText: "Current Location",
      ),
    );

    final submitButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: colorPrimary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            String userId = widget.userData?.id;

            if (userId == null || userId.trim().isEmpty) {
              return;
            }

            if (_regstraionDoc == null) {
              return;
            }

            if (_tradeLicenceDoc == null) {
              return;
            }

            if (_sellerIdDoc == null) {
              return;
            }

            var request =
                ApiCall().getMultipartRequest("detail-registration/$userId");

            //country,location,shop_type,store,product_no, registration_copy,trade_licence_copy,valid_seller_id
            request.fields['country'] = _country;
            request.fields['location'] = _location ?? '';
            request.fields['shop_type'] = _shopType ?? '';
            request.fields['product_no'] = _productCount ?? '';
            request.fields['store'] = _physicalStore;

            if (_regstraionDoc != null) {
              request.files.add(http.MultipartFile.fromBytes(
                  'registration_copy',
                  File(_regstraionDoc.imageStr).readAsBytesSync(),
                  filename: _regstraionDoc.name,
                  contentType: MimeTypes.getContentType(_regstraionDoc)));
            }
            if (_tradeLicenceDoc != null) {
              request.files.add(http.MultipartFile.fromBytes(
                  'trade_licence_copy',
                  File(_tradeLicenceDoc.imageStr).readAsBytesSync(),
                  filename: '2${_tradeLicenceDoc.name}',
                  contentType: MimeTypes.getContentType(_tradeLicenceDoc)));
            }
            if (_sellerIdDoc != null) {
              request.files.add(http.MultipartFile.fromBytes('valid_seller_id',
                  File(_sellerIdDoc.imageStr).readAsBytesSync(),
                  filename: '3${_sellerIdDoc.name}',
                  contentType: MimeTypes.getContentType(_sellerIdDoc)));
            }

            SignupResponse response = await ApiCall()
                .execute<SignupResponse, Null>(
                    'detail-registration/$userId', null,
                    multipartRequest: request);
            if (response?.success != null && response.success == 1
                // && response.vendorData != null
                ) {

              Navigator.pushReplacementNamed(
                context,
                'login',
              );
            }

            // Navigator.of(context).pushReplacementNamed('home');
          }
        },
        child: Text('Save',
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
          'Shop Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                _shopTypeField,
                SizedBox(
                  height: 10,
                ),
                _productCountField,
                SizedBox(
                  height: 10,
                ),
                _countryField,
                SizedBox(
                  height: 10,
                ),
                _locationField,
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Do you have physical store ?',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                    SizedBox(
                      width: 30,
                      child: Consumer<PhysicalStoreClickNotifier>(
                          builder: (context, value, child) => Radio<String>(
                              groupValue: _physicalStore,
                              value: 'yes',
                              activeColor: colorPrimary,
                              onChanged: (val) {
                                _physicalStore = val;
                                _physicalStoreNotifier.radioButtonSelected();
                                // setState(() {
                                //   radioItem = data.name ;
                                //   id = data.index;
                                // }),
                              })),
                    ),
                    InkWell(
                        onTap: () {
                          _physicalStore = 'yes';
                          _physicalStoreNotifier.radioButtonSelected();
                        },
                        child: Text('Yes')),
                    SizedBox(
                      width: 7,
                    ),
                    SizedBox(
                      width: 30,
                      child: Consumer<PhysicalStoreClickNotifier>(
                          builder: (context, value, child) => Radio<String>(
                              groupValue: _physicalStore,
                              value: 'no',
                              activeColor: colorPrimary,
                              onChanged: (val) {
                                _physicalStore = val;
                                _physicalStoreNotifier.radioButtonSelected();
                                // setState(() {
                                //   radioItem = data.name ;
                                //   id = data.index;
                                // }),
                              })),
                    ),
                    InkWell(
                        onTap: () {
                          _physicalStore = 'no';
                          _physicalStoreNotifier.radioButtonSelected();
                        },
                        child: Text('No')),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Company documents ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: '(.doc, .pdf, .docx, .png, .jpg, .jpeg)',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ])),
                SizedBox(
                  height: 20,
                ),

                Consumer<DocsAddedNotifier>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        FDottedLine(
                          color: colorPrimary,
                          strokeWidth: 2.0,
                          dottedLength: 4.0,
                          space: 3.0,
                          corner: FDottedLineCorner.all(3.0),
                          child: InkWell(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: _allowedDocuments,
                              );
                              if (result != null) {
                                _regstraionDoc = FileModel(
                                    fileName: result.files.single.name,
                                    imageStr: result.files.single.path,
                                    imageU8L: result.files.single.bytes);
                                _docsAddedNotifier.docAdded();
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: 100,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: _regstraionDoc != null
                                  ? Text(
                                      _regstraionDoc.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: primaryTextColor),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: primaryTextColor,
                                        ),
                                        Text(
                                          'Commercial registration',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryTextColor),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FDottedLine(
                          color: colorPrimary,
                          strokeWidth: 2.0,
                          dottedLength: 4.0,
                          space: 3.0,
                          corner: FDottedLineCorner.all(3.0),
                          child: InkWell(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: _allowedDocuments,
                              );
                              if (result != null) {
                                _tradeLicenceDoc = FileModel(
                                    fileName: result.files.single.name,
                                    imageStr: result.files.single.path,
                                    imageU8L: result.files.single.bytes);
                                _docsAddedNotifier.docAdded();
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: 100,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: _tradeLicenceDoc != null
                                  ? Text(
                                      _tradeLicenceDoc.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: primaryTextColor),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: primaryTextColor,
                                        ),
                                        Text(
                                          'Trade licence',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryTextColor),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FDottedLine(
                          color: colorPrimary,
                          strokeWidth: 2.0,
                          dottedLength: 4.0,
                          space: 3.0,
                          corner: FDottedLineCorner.all(3.0),
                          child: InkWell(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: _allowedDocuments,
                              );
                              if (result != null) {
                                _sellerIdDoc = FileModel(
                                    fileName: result.files.single.name,
                                    imageStr: result.files.single.path,
                                    imageU8L: result.files.single.bytes);
                                _docsAddedNotifier.docAdded();
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              height: 100,
                              alignment: Alignment.center,
                              child: _sellerIdDoc != null
                                  ? Text(
                                      _sellerIdDoc.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: primaryTextColor),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: primaryTextColor,
                                        ),
                                        Text(
                                          'Valid Seller QID',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryTextColor),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // _shopTypeField,
                // SizedBox(
                //   height: 10,
                // ),
                // _minimumQtyField,
                // SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     Expanded(child: _guaranteeField),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(child: _monthField),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(child: _guaranteePeriodField),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // _searchTagField,
                // SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     Expanded(child: _returnField),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(child: _returnDaysField),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // GridView.count(
                //   crossAxisCount: 3,
                //   shrinkWrap: true,
                //   padding: const EdgeInsets.all(2.0),
                //   primary: false,
                //   childAspectRatio: 1.0,
                //   children: _gridTile(),
                //   mainAxisSpacing: 6.0,
                //   crossAxisSpacing: 6.0,
                // ),
                SizedBox(
                  height: 20,
                ),
                submitButon,
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
