
import 'dart:io';
import 'dart:typed_data';

class MyStatus {
  File file;
  bool isImage;
  Uint8List? thumbnail;
  MyStatus({required this.file, this.isImage = true, this.thumbnail});

  @override
  String toString() {
    return 'MyStatus{file: $file, isImage: $isImage, thumbnail: $thumbnail}';
  }
}