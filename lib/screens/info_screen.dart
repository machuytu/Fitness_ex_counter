import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:get/get.dart';
import 'package:khoaluan/models/arguments_model.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/image_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:khoaluan/widgets/account_field.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen({Key key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  UserService userService = new UserService();
  AuthService _auth = new AuthService();
  ArgumentModel argModel = new ArgumentModel();
  ImageService imageService = new ImageService();

  String imageUrl;
  String arguments = Get.arguments;
  Widget currentPage;
  void callback(Widget nextPage) {
    setState(() {
      this.currentPage = nextPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userService.getUser(_auth),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        argModel = ArgumentModel(user: user, callback: this.callback, imageUrl: arguments);
                        Get.toNamed("/update_account", arguments: argModel);
                      }),
                ],
                backgroundColor: kIndigoColor,
                elevation: 0.0,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: kIndigoColor,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: imageService.getImage(context, _auth.getUser().uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                argModel.imageUrl = snapshot.data;
                                return ClipOval(
                                  child: Image.network(
                                    snapshot.data,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                              return Center(child: CircularProgressIndicator());
                            }),
                        SizedBox(height: 10.0),
                        Text(
                          user.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AccountField(title: "Height", value: user.height.toString(), unit: user.heightUnit),
                        AccountField(
                          title: "Weight",
                          value: user.weight.toString(),
                          unit: user.weightUnit,
                        ),
                        AccountField(title: "Gender", value: user.gender == false ? "Nữ" : "Nam"),
                        user.fitnessMode == 1
                            ? AccountField(
                                title: "Fitness mode",
                                value: "Easy",
                                color: Colors.green,
                              )
                            : user.fitnessMode == 2
                                ? AccountField(
                                    title: "Fitness mode",
                                    value: "Medium",
                                    color: Colors.yellow,
                                  )
                                : AccountField(
                                    title: "Fitness mode",
                                    value: "Hard",
                                    color: Colors.red,
                                  ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
