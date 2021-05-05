import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/firebase_service.dart';
import 'package:khoaluan/services/image_service.dart';
import 'package:khoaluan/services/user_service.dart';

class InfoUser extends StatefulWidget {
  InfoUser({Key key}) : super(key: key);

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  TextEditingController nameUser = new TextEditingController(text: 'Mạc Huy Tú');
  TextEditingController ageUser = new TextEditingController(text: '18');
  TextEditingController weightUser = new TextEditingController();
  TextEditingController heightUser = new TextEditingController();
  AuthService _auth = new AuthService();
  int weightValue, heightValue;
  String kindValue;
  bool isMale = true;
  int fitnessMode = 1;
  String heightUnit, weightUnit;
  ImageService imageService = new ImageService();
  FireStorageService fireStorageService = new FireStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Đăng ký thông tin cá nhân",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: kIndigoColor),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      elevation: 2.0,
                      fillColor: isMale ? Colors.white : Colors.grey[200],
                      child: isMale ? SvgPicture.asset("assets/images/masculine.svg", width: 55) : SvgPicture.asset("assets/images/masculine.svg", color: Colors.white, width: 55),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      elevation: 2.0,
                      fillColor: !isMale ? Colors.white : Colors.grey[200],
                      child: !isMale ? SvgPicture.asset("assets/images/femenine.svg", width: 60) : SvgPicture.asset("assets/images/femenine.svg", color: Colors.white, width: 60),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                imageService.imageFile != null
                    ? Center(
                        child: Image.file(
                          imageService.imageFile,
                          cacheHeight: 200,
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          imageService.imageFile = await imageService.pickImage();
                          setState(() {});
                        },
                        child: Text("Chọn ảnh"),
                      ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: nameUser,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Họ tên trống';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: ageUser,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Tuổi trống';
                        } else if (int.parse(value) > 100) {
                          return 'Tuổi lớn hơn 100';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Tuổi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        child: Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: weightUser,
                            onTap: () {
                              showPickerArray(context, pickerWeight, weightUser, 'weight');
                            },
                            showCursor: true,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Cân nặng',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'cân nặng trống';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Container(
                        child: Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: heightUser,
                            onTap: () {
                              showPickerArray(context, pickerHeight, heightUser, 'height');
                            },
                            showCursor: true,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Chiều cao',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Chiều cao trống';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Chế độ tập luyện",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() => fitnessMode = 1);
                          },
                          elevation: 2.0,
                          fillColor: fitnessMode == 1 ? Colors.white : Colors.grey[200],
                          child: fitnessMode == 1
                              ? SvgPicture.asset("assets/images/skipping_rope.svg", width: 50)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset("assets/images/skipping_rope.svg", width: 50),
                                ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        Text(
                          "Dễ",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() => fitnessMode = 2);
                          },
                          elevation: 2.0,
                          fillColor: fitnessMode == 2 ? Colors.white : Colors.grey[200],
                          child: fitnessMode == 2
                              ? SvgPicture.asset("assets/images/dumbbell.svg", width: 50)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset("assets/images/dumbbell.svg", width: 50),
                                ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        Text(
                          "Trung bình",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() => fitnessMode = 3);
                          },
                          elevation: 2.0,
                          fillColor: fitnessMode == 3 ? Colors.white : Colors.grey[200],
                          child: fitnessMode == 3
                              ? SvgPicture.asset("assets/images/barbell.svg", width: 50)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset("assets/images/barbell.svg", width: 50),
                                ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        Text(
                          "Khó",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: deepBlueColor)),
                      color: deepBlueColor,
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User user = auth.currentUser;
                        UserService userService = new UserService();
                        fireStorageService.uploadImageToFirebase(context, imageService.imageFile, _auth.getUser().uid);
                        userService.setValueRegister(user.uid, nameUser.text, int.parse(ageUser.text), heightValue, heightUnit, weightValue, weightUnit, fitnessMode, isMale);
                        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                        Fluttertoast.showToast(
                          msg: "Nhập thông tin thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      },
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(fontSize: 18, color: kGreenColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPickerArray(BuildContext context, String pickerData, TextEditingController editTextValue, String kindValue) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(pickerData),
          isArray: true,
        ),
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          print(picker.getSelectedValues());
          List list = picker.getSelectedValues();
          setState(() {
            editTextValue.text = list[0] + " " + list[1];
            if (kindValue == 'height') {
              heightValue = int.parse(list[0]);
              heightUnit = list[1];
            }
            if (kindValue == 'weight') {
              weightValue = int.parse(list[0]);
              weightUnit = list[1];
            }
          });
        }).showModal(context);
  }
}
