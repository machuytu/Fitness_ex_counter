import 'package:flutter/material.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/widgets/custom_curve.dart';

class ResigterScreen extends StatefulWidget {
  ResigterScreen({Key key}) : super(key: key);

  @override
  _ResigterScreenState createState() => _ResigterScreenState();
}

class _ResigterScreenState extends State<ResigterScreen> {
  TextEditingController emailValid = new TextEditingController(text: 'machuytu@gmail.com');
  TextEditingController passwordValid = new TextEditingController(text: '123456');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              colorBlendMode: BlendMode.modulate,
              image: AssetImage(
                'assets/images/login_pic.jpg',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomPaint(
              size: Size(600, size.height * 0.8),
              painter: RPSCustomPainter(),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                        height: 200,
                        image: AssetImage(
                          'assets/logo/logo_cricle.png',
                        )),
                    Container(
                      width: size.width * 0.7,
                      child: TextFormField(
                        controller: emailValid,
                        validator: (value) {
                          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                          if (value.trim().isEmpty) {
                            return 'Email trống';
                          } else if (emailValid == false) {
                            return 'Email sai định dạng';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: size.width * 0.7,
                      child: TextFormField(
                        controller: passwordValid,
                        obscureText: true,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Mật khẩu trống';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          AuthService _auth = new AuthService();
                          _auth.registerUser(emailValid.text, passwordValid.text, context);
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            border: Border.all(
                              color: Colors.green[600],
                              width: 8,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Đăng ký",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(text: 'Đã có tài khoản'),
                            TextSpan(text: ' Đăng nhập!', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future buildShowDialog(BuildContext context, String title, String description, {bool returnScreen, String route}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Xác nhận'),
              onPressed: () {
                if (returnScreen == true) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    route,
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
