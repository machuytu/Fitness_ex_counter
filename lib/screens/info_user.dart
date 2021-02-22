import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoUser extends StatefulWidget {
  InfoUser({Key key}) : super(key: key);

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  TextEditingController nameUser = new TextEditingController();
  TextEditingController weightUser = new TextEditingController();
  TextEditingController heighttUser = new TextEditingController();
  int weightValue, heightValue;
  bool isMale = true;
  int modeFitness = 1;
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
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kIndigoColor),
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
                      child: isMale
                          ? SvgPicture.asset("assets/images/masculine.svg",
                              width: 55.0)
                          : SvgPicture.asset("assets/images/masculine.svg",
                              color: Colors.white, width: 55.0),
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
                      child: !isMale
                          ? SvgPicture.asset("assets/images/femenine.svg",
                              width: 60.0)
                          : SvgPicture.asset("assets/images/femenine.svg",
                              color: Colors.white, width: 60.0),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ],
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
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        child: Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: weightUser,
                            onTap: () {
                              showPickerArray(
                                  context, pickerWeight, weightUser);
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
                            controller: heighttUser,
                            onTap: () {
                              showPickerArray(
                                  context, pickerHeight, heighttUser);
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
                            setState(() => modeFitness = 1);
                          },
                          elevation: 2.0,
                          fillColor: modeFitness == 1
                              ? Colors.white
                              : Colors.grey[200],
                          child: modeFitness == 1
                              ? SvgPicture.asset(
                                  "assets/images/skipping_rope.svg",
                                  width: 50.0)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset(
                                      "assets/images/skipping_rope.svg",
                                      width: 50.0),
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
                            setState(() => modeFitness = 2);
                          },
                          elevation: 2.0,
                          fillColor: modeFitness == 2
                              ? Colors.white
                              : Colors.grey[200],
                          child: modeFitness == 2
                              ? SvgPicture.asset("assets/images/dumbbell.svg",
                                  width: 50.0)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset(
                                      "assets/images/dumbbell.svg",
                                      width: 50.0),
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
                            setState(() => modeFitness = 3);
                          },
                          elevation: 2.0,
                          fillColor: modeFitness == 3
                              ? Colors.white
                              : Colors.grey[200],
                          child: modeFitness == 3
                              ? SvgPicture.asset("assets/images/barbell.svg",
                                  width: 50.0)
                              : Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset(
                                      "assets/images/barbell.svg",
                                      width: 50.0),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: deepBlueColor)),
                      color: deepBlueColor,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (Route<dynamic> route) => false);
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

  showPickerArray(BuildContext context, String pickerData,
      TextEditingController editTextValue) {
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
            weightValue = int.parse(list[0]);
          });
        }).showModal(context);
  }
}
