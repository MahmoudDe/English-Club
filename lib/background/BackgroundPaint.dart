// ignore_for_file: file_names

import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*2.1434668500180276).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class AppBarCustom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    Paint paintFill0 = Paint()
      ..color = const Color.fromARGB(101, 104, 58, 183)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 1.0027750, size.height * 0.3791429);
    path_0.quadraticBezierTo(size.width * 0.8861583, size.height * 0.4673714,
        size.width * 0.7158667, size.height * 0.4736571);
    path_0.cubicTo(
        size.width * 0.5189083,
        size.height * 0.4581571,
        size.width * 0.4263333,
        size.height * 0.3872857,
        size.width * 0.2027083,
        size.height * 0.3632143);
    path_0.quadraticBezierTo(size.width * 0.1113333, size.height * 0.3655000,
        size.width * -0.0005917, size.height * 0.4370000);
    path_0.lineTo(size.width * -0.0083333, size.height * 0.0028571);
    path_0.lineTo(size.width * 1.0025000, size.height * 0.0028571);
    path_0.lineTo(size.width * 1.0027500, size.height * 0.3726429);

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    Paint paintStroke0 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke0);

    // Layer 1 Copy

    Paint paintFill1 = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.9983333, size.height * 0.3321714);
    path_1.quadraticBezierTo(size.width * 0.8576917, size.height * 0.4263714,
        size.width * 0.6874000, size.height * 0.4326571);
    path_1.cubicTo(
        size.width * 0.4904417,
        size.height * 0.4171571,
        size.width * 0.4298750,
        size.height * 0.3429857,
        size.width * 0.2062500,
        size.height * 0.3189143);
    path_1.quadraticBezierTo(size.width * 0.1148750, size.height * 0.3212000,
        size.width * -0.0041583, size.height * 0.3926429);
    path_1.lineTo(size.width * -0.0083333, size.height * 0.0028571);
    path_1.lineTo(size.width * 1.0025000, size.height * 0.0028571);
    path_1.lineTo(size.width * 0.9974417, size.height * 0.2827571);

    canvas.drawPath(path_1, paintFill1);

    // Layer 1 Copy

    Paint paintStroke1 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_1, paintStroke1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
