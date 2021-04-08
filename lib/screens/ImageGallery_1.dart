import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageGallery extends StatefulWidget {
  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}
class _ImageGalleryState extends State<ImageGallery> {
  var image;
  List imageArray = [];  
  
  _openGallery()async{
  image = await ImagePicker.pickImage(source: ImageSource.gallery);
  imageArray.add(image);
  setState(() {
    imageArray;
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        
      ),
      body: Container(
        child: Column(
          children:<Widget>[
            Container(
              child: FlatButton(
                onPressed: (){
                  _openGallery();
                },
                splashColor: Colors.blueAccent,
                color: Colors.blue,
                textColor: Colors.white,
                child: Center(
                  child: Text('open gallery'),
                ))),         
            Container(
              height: MediaQuery.of(context).size.height * .8,
              // decoration: BoxDecoration(border: Border.all(width: 2)),
             padding: EdgeInsets.all(5),
              child: imageArray.isEmpty ? Center(child: Text("No Image")): GridView.count(crossAxisCount: 2,
              children: List.generate(imageArray.length, (index){
                var img = imageArray[index];
                return Image.file(img);
              }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
