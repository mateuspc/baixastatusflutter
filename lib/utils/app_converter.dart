
import 'dart:io';
import 'dart:typed_data';

import 'package:baixar_status/models/my_status.dart';

Uint8List getBytesFromFile(String path) {
  File file = File(path);
  Uint8List bytes = file.readAsBytesSync();
  return bytes;
}