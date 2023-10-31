import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 56, 142, 60)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width*-0.1645875,size.height*0.7018500);
    path_0.quadraticBezierTo(size.width*-0.2549625,size.height*1.4298000,size.width*0.1254125,size.height*0.4986000);
    path_0.cubicTo(size.width*0.3297250,size.height*0.0551500,size.width*0.3760375,size.height*1.0365500,size.width*1.0135750,size.height*0.6835500);
    path_0.quadraticBezierTo(size.width*1.3439125,size.height*0.2816000,size.width*1.2295750,size.height*-0.4146000);
    path_0.lineTo(size.width*1.1054125,size.height*-0.5181500);
    path_0.lineTo(size.width*-0.1295875,size.height*-1.0881500);
    path_0.lineTo(size.width*-0.1645875,size.height*0.7018500);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1 Copy

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(95, 56, 142, 60)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_1 = Path();
    path_1.moveTo(size.width * -0.2391754, size.height * 1.1277191);
    path_1.quadraticBezierTo(size.width * -0.2447767, size.height * 1.4894995,
        size.width * 0.1516057, size.height * 0.6212264);
    path_1.cubicTo(
        size.width * 0.3645034,
        size.height * 0.2077006,
        size.width * 0.3691875,
        size.height * 1.1999000,
        size.width * 1.0293500,
        size.height * 0.8707000);
    path_1.quadraticBezierTo(size.width * 1.3735875, size.height * 0.4958500,
        size.width * 1.209439 * size.width, size.height * -006703);
    path_1.lineTo(size.width * 1.0800515 * size.width, size.height * -0098527);
    path_1.lineTo(size.width * -2026943 * size.width, size.height * -3548535);
    path_1.lineTo(size.width * -2391754 * size.width, size.height * 11277191);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
