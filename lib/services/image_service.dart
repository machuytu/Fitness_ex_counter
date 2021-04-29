import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  File imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future getImage() async {
    final ref = FirebaseStorage.instance.ref().child('upload').child("image_picker2636661780889139429.jpg}");
    var url = await ref.getDownloadURL();
    print('>>>' + url);
  }
}
