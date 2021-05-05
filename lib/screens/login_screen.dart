import 'package:flutter/material.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/widgets/custom_curve.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = new AuthService();
  final emailValid = new TextEditingController(text: 'phuc@gmail.com');
  final passwordVaild = new TextEditingController(text: '123456');

  @override
  void dispose() {
    emailValid.dispose();
    passwordVaild.dispose();
    super.dispose();
  }

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
                        controller: passwordVaild,
                        obscureText: true,
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
                          _auth.loginUser(emailValid.text, passwordVaild.text, context);
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
                              "Đăng nhập",
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
                        Navigator.pushNamedAndRemoveUntil(context, "/register", (Route<dynamic> route) => false);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(text: 'Chưa có tài khoản? '),
                            TextSpan(text: 'Đăng ký!', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(59, 89, 152, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(59, 89, 152, 1),
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Đăng nhập với Facebook",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(234, 67, 53, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(234, 67, 53, 1),
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Đăng nhập với Gmail",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Future buildShowDialog(
    BuildContext context,
    String title,
    String description, {
    bool returnScreen,
    String route,
  }) {
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
              child: Text('OK'),
              onPressed: () {
                if (returnScreen == true) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, route, (Route<dynamic> route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
