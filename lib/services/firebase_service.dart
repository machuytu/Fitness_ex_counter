import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    return await firebase_storage.FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

  Future uploadImageToFirebase(BuildContext context, File _imageFile) async {
    String fileName = _imageFile.path;
    String basename = path.basename(fileName);
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child('upload/$basename}');

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        print("Done: $fileURL");
      });
    });
  }
}
