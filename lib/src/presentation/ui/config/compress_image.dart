import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressFile(File file) async {
  try {
    final bytes = file.readAsBytesSync().lengthInBytes;
    var kb = bytes / 1024;
    var mb = kb / 1024;
    if (mb > 1) {
      final quality = (100 / mb).floor();
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: quality,
      );
      final bytes = result?.readAsBytesSync().lengthInBytes;
      kb = (bytes! / 1024);
      mb = kb / 1024;
      file = result!;
    }

    return file;
  } catch (e) {
    print('Error In Compressing Image: $e');
    return file;
  }
}

bool isImageLesserThanDefinedSize(File file) {
  final bytes = file.readAsBytesSync().lengthInBytes;
  var kb = bytes / 1024;
  var mb = kb / 1024;

  if (mb < 6) {
    return true;
  } else {
    return false;
  }
}
