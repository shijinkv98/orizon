import 'dart:typed_data' show Uint8List;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';

class FileModel {
  String name;
  final String imageStr;
  final Uint8List imageU8L;
  final bool isNetwork;
  FileModel(
      {@required String fileName,
      this.imageStr,
      this.imageU8L,
      this.isNetwork = false}) {
    name = fileName.split(Platform.pathSeparator).last;
  }
}
