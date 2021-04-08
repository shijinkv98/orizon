import 'dart:io';
import 'dart:convert' show json;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/custom/fdottedline.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/helpers/mime_type.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/category_response.dart';
import 'package:vendor_app/notifiers/product_notifier.dart';
import 'package:vendor_app/screens/home/ad_manager.dart';

class AddNewProduct extends StatefulWidget {
  String slug;
  AddNewProduct(String slug)
  {
    this.slug=slug;
  }
  @override
  _AddNewProductState createState() => _AddNewProductState(slug: this.slug);
}

Future<GetUsers> fetchData() async {
  var user = await getUser();
  Data data = Data(user);
  userId = data.user.id;
  userToken = data.user.token;
  return null;
}

int image_count = 0;

class _AddNewProductState extends State<AddNewProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  final List<FileModel> _images = List();

  ImageAddedNotifier _imageAddedNotifier;
  AddProductLoadingNotifier _loadingNotifier;
  CategorySelectedNotifier _categorySelectedNotifier;
  _AddNewProductState({this.slug});
  String slug;
  File imageFile;

  @override
  void initState() {
    super.initState();
    _images.add(null);
    image_count = 0;
    _imageAddedNotifier =
        Provider.of<ImageAddedNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<AddProductLoadingNotifier>(context, listen: false);
    _categorySelectedNotifier =
        Provider.of<CategorySelectedNotifier>(context, listen: false);
    fetchData();
    // ApiCall().execute<CategoryResponse, Null>('getcategories', null);
  }

  _DropdownModel _mainCategory;
  _DropdownModel _subCategory;
  _DropdownModel _manufacturers;
  Map<String, _DropdownModel> _specifications = new Map();
  List<_DropdownModel> _subCategories;
  String _productName, _desscription, _mrp, _sellingPrice, _stock;
  String _minimumQty, _searchTag, _return, _returnDays, _orderNo;

  @override
  Widget build(BuildContext context) {
    final productNameField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _productName = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Product name",
        labelText: 'Product name',
      ),
    );

    final _desscriptionField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _desscription = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
        } else {
          return null;
        }
      },
      maxLines: 5,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      // textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Description",
        labelText: 'Desscription',
      ),
    );

    final _mrpField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _mrp = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "MRP",
        labelText: 'MRP',
      ),
    );

    final _sellingPriceField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _sellingPrice = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Selling price",
        labelText: 'Selling price',
      ),
    );

    final _stockField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _stock = value;
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
        hintText: "Stock",
        labelText: 'Stock',
      ),
    );

    final _minimumQtyField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _minimumQty = value;
      },
      initialValue: _minimumQty,
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
        hintText: "Minimum purchase quantity",
        labelText: 'Minimum purchase quantity',
      ),
    );

    final _searchTagField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _searchTag = value;
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
        hintText: "Search tag",
        labelText: 'Search tag',
      ),
    );

    // var _guaranties = ['Guarantee', 'Warranty'];
    // String _guarantee;
    // final _guaranteeField = DropdownButtonFormField(
    //   value: _guarantee,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
    //     hintStyle: TextStyle(fontSize: 14),
    //     labelStyle: TextStyle(fontSize: 14),
    //     hintText: 'Guarantee',
    //     labelText: 'Guarantee',
    //   ),
    //   isExpanded: true,
    //   isDense: true,
    //   onChanged: (String newValue) {
    //     // setState(() {
    //     _guarantee = newValue;
    //     // state.didChange(newValue);
    //     // });
    //   },
    //   items: _guaranties.map((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(
    //         value,
    //         style: TextStyle(fontSize: 14),
    //       ),
    //     );
    //   }).toList(),
    // );

    // var _guaranteePriods = ['Month', 'Year'];
    // String _month;
    // final _monthField = DropdownButtonFormField(
    //   value: _month,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
    //     hintStyle: TextStyle(fontSize: 14),
    //     labelStyle: TextStyle(fontSize: 14),
    //     hintText: 'Month',
    //     labelText: 'Month',
    //   ),
    //   isExpanded: true,
    //   isDense: true,
    //   onChanged: (String newValue) {
    //     // setState(() {
    //     _month = newValue;
    //     // state.didChange(newValue);
    //     // });
    //   },
    //   items: _guaranteePriods.map((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(
    //         value,
    //         style: TextStyle(fontSize: 14),
    //       ),
    //     );
    //   }).toList(),
    // );

    // String _guaranteePeriod = '0';
    // final _guaranteePeriodField = TextFormField(
    //   obscureText: false,
    //   onSaved: (value) {
    //     _guaranteePeriod = value;
    //   },
    //   initialValue: _guaranteePeriod,
    //   style: style,
    //   validator: (value) {
    //     if (value.trim().isEmpty) {
    //       return 'This field is required';
    //     } else {
    //       return null;
    //     }
    //   },
    //   keyboardType: TextInputType.number,
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    //     hintText: "Period",
    //     labelText: 'Period',
    //   ),
    // );
    var _returnsArray = ['Return', 'Replace'];
    final _returnField = DropdownButtonFormField(
      value: _return,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
        hintStyle: TextStyle(fontSize: 14),
        labelStyle: TextStyle(fontSize: 14),
        hintText: 'Return',
        labelText: 'Return',
      ),
      isExpanded: true,
      isDense: true,
      onChanged: (String newValue) {
        // setState(() {
        _return = newValue;
        // state.didChange(newValue);
        // });
      },
      items: _returnsArray.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );

    final _returnDaysField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _returnDays = value;
      },
      initialValue: _returnDays,
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
        hintText: "Days",
        labelText: 'Days',
      ),
    );

    final _orderNoField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        _orderNo = value;
      },
      initialValue: _orderNo,
      style: style,
      // validator: (value) {
      // if (value.trim().isEmpty) {
      //   return 'This field is required';
      // } else {
      //   return null;
      // }
      // },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Order number",
        labelText: 'Order number',
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
          // Navigator.of(context).pushReplacementNamed('/home');
          List<Map> specList = [];
          _specifications.forEach((key, value) {
            specList.add({'specification_id': key, 'value_id': value.id});
          });
          debugPrint(' selected specifications ${json.encode(specList)}');
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
// category,name,description,stock,default_price,current_price,tags,min_quantity,stock_alert_quantity,imageFile,manufacturer_id,specifications

            var request = ApiCall().getMultipartRequest('addproduct');

            request.fields['category'] =
                _subCategory?.id ?? _mainCategory.id ?? '';
            request.fields['name'] = _productName;
            request.fields['description'] = _desscription;
            request.fields['stock'] = _stock;
            request.fields['default_price'] = _mrp;
            request.fields['current_price'] = _sellingPrice;
            request.fields['tags'] = _searchTag;
            request.fields['min_quantity'] = _minimumQty;
            request.fields['order_number'] = _orderNo;
            request.fields['stock_alert_quantity'] = '1';
            request.fields['manufacturer_id'] = _manufacturers.id.toString();
            request.fields['return_period'] = _returnDays ?? '0';
            // request.fields['sortorder_in_vendorapp'] = _orderNo;
            request.fields['specifications'] = json.encode(specList);
            _images.forEach((element) {
              if (element != null) {
                request.files.add(http.MultipartFile.fromBytes(
                    'imageFile[]',
                    // File(element.imageStr).readAsBytesSync(),
                    element.imageU8L,
                    filename: element.name ?? 'ProductImag.jpg',
                    contentType: MimeTypes.getContentType(element)));
              }
            });
            _loadingNotifier.isLoading = true;
            ApiCall()
                .executeNew('addproduct', userId, userToken, null,slug,
                    multipartRequest: request)
                .then((value) {
              _loadingNotifier.isLoading = false;
              ApiCall().showAlertDialogProduct("Successfully updated",mStoreSlug);
              // _showAlertDialogProduct(store)
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProductsScreen()),
              // );
            });
          }
        },
        child: Text("Save",
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
          'Add item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<CategoryResponse>(
          future:
              ApiCall().execute<CategoryResponse, Null>('getcategories', null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> specifications = [];
              // snapshot.data.specification.asMap().forEach((key, value) {});
              snapshot.data.specification.forEach((element) {
                specifications.add(_DropdownField(
                  hintText: element.name,
                  labelText: element.name,
                  list: element.values
                      .map((e) => _DropdownModel(e.id, e.name))
                      .toList(),
                  value: _specifications[element.specificationId],
                  onChanged: (newValue) {
                    _specifications[element.specificationId] = newValue;
                  },
                  isMandatory: false,
                ));
                specifications.add(SizedBox(height: 10));
              });

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            _DropdownField(
                              hintText: 'Main category',
                              labelText: 'Main category',
                              list: snapshot.data.categories
                                  .where((element) =>
                                      element.subcategorieslanguage != null &&
                                      element.subcategorieslanguage.isNotEmpty)
                                  .map((e) =>
                                      _DropdownModel(e.id, e.language.name))
                                  .toList(),
                              value: _mainCategory,
                              onChanged: (newValue) {
                                //_subCategories.clear();
                                debugPrint(
                                    'Main category dropdown onChanged: $newValue');
                                if (_subCategories != null)
                                  _subCategory = newValue;

                                _subCategories = snapshot.data.categories
                                    .firstWhere(
                                        (element) => element.id == newValue.id)
                                    .subcategorieslanguage
                                    .map((e) => _DropdownModel(e.id, e.name))
                                    .toList();
                                _mainCategory = newValue;
                                _subCategory = _subCategories[0];
                                // _subCategory=newValue;
                                _categorySelectedNotifier.categorySelected();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Consumer<CategorySelectedNotifier>(
                              builder: (context, value, child) {
                                return _subCategories != null &&
                                        _subCategories.isNotEmpty
                                    ? _DropdownField(
                                        hintText: 'Sub category',
                                        labelText: 'Sub category',
                                        list: _subCategories,
                                        value: _subCategory,
                                        onChanged: (newValue) {
                                          _subCategory = newValue;
                                        },
                                      )
                                    : SizedBox();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            productNameField,
                            SizedBox(
                              height: 10,
                            ),
                            _desscriptionField,
                            SizedBox(
                              height: 10,
                            ),
                            _mrpField,
                            SizedBox(
                              height: 10,
                            ),
                            _sellingPriceField,
                            SizedBox(
                              height: 10,
                            ),
                            _stockField,
                            SizedBox(
                              height: 10,
                            ),
                            _minimumQtyField,
                            SizedBox(
                              height: 10,
                            ),
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
                            snapshot.data.manufacturers != null &&
                                    snapshot.data.manufacturers.isNotEmpty
                                ? _DropdownField(
                                    hintText: 'Fast Moving  ',
                                    labelText: 'Manufacturers',
                                    list: snapshot.data.manufacturers
                                        .map(
                                            (e) => _DropdownModel(e.id, e.name))
                                        .toList(),
                                    value: _manufacturers,
                                    onChanged: (newValue) {
                                      _manufacturers = newValue;
                                    },
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 10,
                            ),
                            _searchTagField,
                            SizedBox(
                              height: 10,
                            ),
                            _orderNoField,
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(child: _returnField),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: _returnDaysField),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]
                            ..addAll(specifications)
                            ..addAll([
                              Consumer<ImageAddedNotifier>(
                                builder: (context, value, child) =>
                                    GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(2.0),
                                  primary: false,
                                  childAspectRatio: 1.0,
                                  children: _gridTile(),
                                  mainAxisSpacing: 6.0,
                                  crossAxisSpacing: 6.0,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              submitButon,
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                        ),
                      ),
                    ),
                  ),
                  Consumer<AddProductLoadingNotifier>(
                    builder: (context, value, child) {
                      return value.isLoading ? progressBar : SizedBox();
                    },
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return errorScreen('Error: ${snapshot.error}');
            } else {
              return progressBar;
            }
          }),
    );
  }

  List<GridTile> _gridTile() {
    return _images
        .asMap()
        .map((key, element) =>
            MapEntry(key, GridTile(child: addImage(key, element))))
        .values
        .cast<GridTile>()
        .toList();

    // return [
    //   GridTile(
    //     child: addImage,
    //   ),
    // ].toList();
  }

  Widget addImage(int index, FileModel imageModel) => FDottedLine(
        color: colorPrimary,
        strokeWidth: 2.0,
        dottedLength: 4.0,
        space: 3.0,
        corner: FDottedLineCorner.all(3.0),
        child: InkWell(
          onTap: () {
            if (image_count < 3) {
              image_count++;
              _showAlertDialog(context, index, imageModel);
            } else {
              ApiCall().showToast("Limit Exceeded(Maximum 3 Product Images)");
            }
          },
          child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 100,
              alignment: Alignment.center,
              child: getGridChild(index, imageModel)),
        ),
      );

  Widget getGridChild(int index, FileModel imageModel) {
    if (imageModel == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 30,
            color: primaryTextColor,
          ),
          Text(
            'Upload Image',
            style: TextStyle(fontSize: 12, color: primaryTextColor),
          ),
        ],
      );
    } else if (imageModel.imageU8L != null && imageModel.imageU8L.length > 0) {
      return Image.memory(imageModel.imageU8L);
    } else if (imageModel.imageStr != null &&
        imageModel.imageStr.trim().isNotEmpty &&
        imageModel.isNetwork) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/no_image.png',
        image: imageModel.imageStr,
      );
    } else {
      return Image.file(File(imageModel.imageStr));
    }
  }

// replace this function with the examples above
  _showAlertDialog(BuildContext context, int index, FileModel imageModel) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Take image with camera'),
      onPressed: () {
        _getFromCamera();
        // ImagePicker()
        //     .getImage(source: ImageSource.camera, imageQuality: 70)
        //     .then((value) => {
        //           value.readAsBytes().then((imageU8L) {
        //             _images.insert(index,
        //                 FileModel(imageU8L: imageU8L, fileName: value.path));
        //             _imageAddedNotifier.imageAdded();
        //           })
        //         });
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: const Text('Upload image from gallery'),
      onPressed: () {
        _getFromGallery();
        // ImagePicker()
        //     .getImage(source: ImageSource.gallery, imageQuality: 70)
        //     .then((value) {
        //   // debugPrint('MJM ImagePicker gallery $value');
        //   value.readAsBytes().then((imageU8L) {
        //     _images.insert(
        //         index, FileModel(imageU8L: imageU8L, fileName: value.path));
        //     _imageAddedNotifier.imageAdded();
        //   });
        // });
        // FilePicker.platform
        //     .pickFiles(type: FileType.image, allowMultiple: true)
        //     .then((value) {
        //   _images.insertAll(
        //       index,
        //       value.files.map((e) => FileModel(
        //           fileName: e.name, imageStr: e.path, imageU8L: e.bytes)));
        //   _imageAddedNotifier.imageAdded();
        // });
        Navigator.of(context).pop();
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Upload Image'),
          children: <Widget>[
            optionOne,
            optionTwo,
          ],
        );
      },
    );
  }

  // Widget _dropdownField(
  //     {_DropdownModel value,
  //     List<_DropdownModel> list,
  //     ValueChanged<_DropdownModel> onChanged,
  //     String hintText,
  //     String labelText,
  //     bool isMandatory = true}) {
  //   if (list == null) {
  //     list = List();
  //   }
  //   return DropdownButtonFormField<_DropdownModel>(
  //     value: value,
  //     isExpanded: true,
  //     isDense: true,
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
  //       hintText: hintText,
  //       labelText: labelText,
  //     ),
  //     onChanged: (_DropdownModel newValue) {
  //       if (newValue != value && onChanged != null) {
  //         onChanged(newValue);
  //       }
  //     },
  //     validator: (value) {
  //       if (isMandatory && value == null) {
  //         return 'This field is required';
  //       } else {
  //         return null;
  //       }
  //     },
  //     items: list.map((_DropdownModel value) {
  //       return DropdownMenuItem<_DropdownModel>(
  //         value: value,
  //         child: Text(value.title),
  //       );
  //     }).toList(),
  //   );
  // }

  @override
  void dispose() {
    _loadingNotifier.reset();
    super.dispose();
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
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();
      _images.insert(0, FileModel(imageU8L: bytes, fileName: filePath));
      _imageAddedNotifier.imageAdded();
      setState(() {
        // debugPrint('MJM ImagePicker gallery $value');
        // _images.add(
        //    FileModel(imageU8L: bytes, fileName: filePath));
        // _imageAddedNotifier.imageAdded();
      });

      // });
    }
  }

  void _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
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
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();
      _images.insert(0, FileModel(imageU8L: bytes, fileName: filePath));
      _imageAddedNotifier.imageAdded();
      setState(() {
        // debugPrint('MJM ImagePicker gallery $value');
      });

      // });
    }
  }
}

class _DropdownModel {
  final String id, title;
  _DropdownModel(this.id, this.title);
}

class _DropdownField extends StatelessWidget {
  _DropdownModel value;
  List<_DropdownModel> list;
  ValueChanged<_DropdownModel> onChanged;
  String hintText;
  String labelText;
  bool isMandatory = true;

  _DropdownField(
      {this.value,
      this.list,
      this.onChanged,
      this.hintText,
      this.labelText,
      this.isMandatory = true}) {
    if (list == null) {
      list = List();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value?.id,
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: hintText,
        labelText: labelText,
      ),
      onChanged: (String newValue) {
        if ((value == null || newValue != value.id) && onChanged != null) {
          onChanged(list.firstWhere((element) => element.id == newValue));
        }
      },
      validator: (value) {
        if (isMandatory && value == null) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      items: list.map((_DropdownModel value) {
        return DropdownMenuItem<String>(
          value: value.id,
          child: Text(value.title),
        );
      }).toList(),
    );
  }
}

// class _DropdownField extends StatefulWidget {
//   _DropdownModel value;
//   List<_DropdownModel> list;
//   ValueChanged<_DropdownModel> onChanged;
//   String hintText;
//   String labelText;
//   bool isMandatory = true;

//   _DropdownField(
//       {this.value,
//       this.list,
//       this.onChanged,
//       this.hintText,
//       this.labelText,
//       this.isMandatory = true}) {
//     if (list == null) {
//       list = List();
//     }
//   }

//   @override
//   __DropdownFieldState createState() => __DropdownFieldState();
// }

// class __DropdownFieldState extends State<_DropdownField> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: widget.value?.id,
//       isExpanded: true,
//       isDense: true,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//         hintText: widget.hintText,
//         labelText: widget.labelText,
//       ),
//       onChanged: (String newValue) {
//         if ((widget.value == null || newValue != widget.value?.id) &&
//             widget.onChanged != null) {
//           widget.onChanged(
//               widget.list.firstWhere((element) => element.id == newValue));
//         }
//       },
//       validator: (value) {
//         if (widget.isMandatory && value == null) {
//           return 'This field is required';
//         } else {
//           return null;
//         }
//       },
//       items: widget.list.map((_DropdownModel value) {
//         return DropdownMenuItem<String>(
//           value: value.id,
//           child: Text(value.title),
//         );
//       }).toList(),
//     );
//   }
// }
