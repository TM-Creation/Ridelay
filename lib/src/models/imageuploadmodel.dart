/// file : PickedFile object

import 'package:image_picker/image_picker.dart';

class FileUploadModel {
  FileUploadModel({
    PickedFile? file,
  }) {
    _file = file;
  }

  FileUploadModel.fromJson(dynamic json) {
    if (json['file'] != null) {
      _file = PickedFile(json['file']);
    }
  }

  PickedFile? _file;

  FileUploadModel copyWith({
    PickedFile? file,
  }) =>
      FileUploadModel(
        file: file ?? _file,
      );

  PickedFile? get file => _file;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_file != null) {
      map['file'] = _file!.path;
    }
    return map;
  }
}
