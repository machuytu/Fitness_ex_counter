import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khoaluan/services/firebase_service.dart';

class ImageService {
  File imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future<String> getImage(BuildContext context, String uid) async {
    String url;
    await FireStorageService.loadFromStorage(context, uid).then((downloadUrl) async {
      ListResult listResult = downloadUrl;
      await listResult.items[0].getDownloadURL().then((value) {
        url = value;
      });
    });
    return url;
  }
}
