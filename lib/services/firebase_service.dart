import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String uid) async {
    return await firebase_storage.FirebaseStorage.instance.ref().child(uid).listAll();
  }

  Future uploadImageToFirebase(BuildContext context, File _imageFile, String userId) async {
    String fileName = _imageFile.path;
    String basename = path.basename(fileName);
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child('$userId/$basename');

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        print("Done: $fileURL");
      });
    });
  }

  Future updateImageToFirebase(BuildContext context, File _imageFile, String userId, String oldImage) async {
    String fileName = _imageFile.path;
    String basename = path.basename(fileName);
    File oldFile = await file(oldImage);
    String basenameOld = path.basename(oldFile.path);
    firebase_storage.Reference storageReferenceOld = FirebaseStorage.instance.refFromURL(oldImage);
    await storageReferenceOld.delete();
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child('$userId/$basename');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        print("Done: $fileURL");
      });
    });
  }

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, filename);
    return File(pathName);
  }
}
