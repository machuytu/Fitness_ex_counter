import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.27);
    path_0.lineTo(0, size.height * 1.01);
    path_0.lineTo(size.width, size.height * 1.01);
    path_0.lineTo(size.width, size.height * 0.27);
    path_0.quadraticBezierTo(size.width * 0.84, size.height * 0.34,
        size.width * 0.50, size.height * 0.33);
    path_0.quadraticBezierTo(
        size.width * 0.17, size.height * 0.34, 0, size.height * 0.27);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
