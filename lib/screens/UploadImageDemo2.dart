import 'dart:io';
import 'dart:convert' show json;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
import 'package:vendor_app/screens/home/dashboard.dart';
import 'package:vendor_app/screens/home/home.dart';
import 'package:vendor_app/screens/products/products.dart';
import 'package:vendor_app/screens/subscribe_ad.dart';

class UploadImageDemo2 extends StatefulWidget {
  @override
  _UploadImageDemo2State createState() => _UploadImageDemo2State();
}
Future<GetUsers> fetchData() async
{
  var user = await getUser();
  Data data = Data(user);
  userId = data.user.id;
  userToken = data.user.token;
  return null;
}
class _UploadImageDemo2State extends State<UploadImageDemo2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  final List<FileModel> _images = List();
  Future<bool> _onBackPressed(BuildContext context,Widget widget) {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: Row(
          children: [
            new Text('Are you sure'),SizedBox(width: 5,),Text('?',style: TextStyle(color: Colors.red),),
          ],
        ),
        content: new Text('Upload Your Banner Here'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),

        ],
      ),
    ) ??
        false;
  }

  ImageAddedNotifier _imageAddedNotifier;
  AddProductLoadingNotifier _loadingNotifier;
  CategorySelectedNotifier _categorySelectedNotifier;

  File imageFile;

  @override
  void initState() {
    super.initState();
    _images.add(null);
    _imageAddedNotifier =
        Provider.of<ImageAddedNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<AddProductLoadingNotifier>(context, listen: false);
    _categorySelectedNotifier =
        Provider.of<CategorySelectedNotifier>(context, listen: false);
    fetchData();
    // ApiCall().execute<CategoryResponse, Null>('getcategories', null);
  }


  Map<String, _DropdownModel> _specifications = new Map();

  @override
  Widget build(BuildContext context) {
    final submitButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: colorPrimary,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed('/home');

          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
// category,name,description,stock,default_price,current_price,tags,min_quantity,stock_alert_quantity,imageFile,manufacturer_id,specifications

            var request = ApiCall().getMultipartRequest('admanager/banners');

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
                .executeImageAdd(
                'admanager/banners', userId, userToken, adMangerId, null,
                multipartRequest: request)
                .then((value) {
              _loadingNotifier.isLoading = false;
              ApiCall().showToast("Successfully updated");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
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
    List<Widget> specifications = [];
    return  WillPopScope(
        onWillPop: () async => _onBackPressed(context,widget),
        child:Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Banners',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
       automaticallyImplyLeading: false,
        backgroundColor: colorPrimary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                _onBackPressed(context, widget);
              },

            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body:
      // FutureBuilder<CategoryResponse>(
          // future:
          // ApiCall().execute<CategoryResponse, Null>('getcategories', null),
          // builder: (context, snapshot) {
          //   if (snapshot.hasData) {
          //     List<Widget> specifications = [];
              // snapshot.data.specification.asMap().forEach((key, value) {});
              // snapshot.data.specification.forEach((element) {
              //   specifications.add(SizedBox(height: 10));
              // });

              // return
                Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Promotion Banners",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ]..addAll(specifications)..addAll([
                            Consumer<ImageAddedNotifier>(
                              builder: (context, value, child) =>
                                  GridView.count(
                                    crossAxisCount: 1,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(2.0),
                                    primary: false,
                                    childAspectRatio: 2.8,
                                    children: _gridTile(),
                                    mainAxisSpacing: 1.0,
                                    crossAxisSpacing: 5.0,
                                  ),
                            ),
                            Text(
                              'Image resolution 320x320',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
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
              )

          // }),
    ),
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
  }

  Widget addImage(int index, FileModel imageModel) =>
      FDottedLine(
        color: colorPrimary,
        strokeWidth: 2.0,
        dottedLength: 4.0,
        space: 3.0,
        corner: FDottedLineCorner.all(3.0),
        child: InkWell(
          onTap: () {
            _showAlertDialog(context, index, imageModel);
          },
          child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 120,
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
        imageModel.imageStr
            .trim()
            .isNotEmpty &&
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
        _getFromCamera(); // ImagePicker()


        Navigator.of(context).pop();
      },
    );

    Widget optionTwo = SimpleDialogOption(
      child: const Text('Upload image from gallery'),
      onPressed: () {
        _getFromGallery();


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
      _images.insert(0,
          FileModel(imageU8L: bytes, fileName: filePath));
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
      _images.insert(
          0, FileModel(imageU8L: bytes, fileName: filePath));
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
Future<void> showDialogueBox(BuildContext context,Widget widget)
{
  return showDialog(context: context,
      builder: (ctx) => AlertDialog(
        title: Text("ALERT !!",style: TextStyle(color: Colors.red),),
        content: Text("Add your Banner here"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Ok"),
          ),

        ],
      ));
}
