import 'dart:ui' as ui;
import 'package:flutter/material.dart';


class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 56, 142, 60)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*-0.1145875,size.height*0.7018500);
    path_0.quadraticBezierTo(size.width*-0.2049625,size.height*1.4298000,size.width*0.1754125,size.height*0.4986000);
    path_0.cubicTo(size.width*0.3797250,size.height*0.0551500,size.width*0.4260375,size.height*1.0365500,size.width*0.9635750,size.height*0.6835500);
    path_0.quadraticBezierTo(size.width*1.2939125,size.height*0.2816000,size.width*1.1795750,size.height*-0.4146000);
    path_0.lineTo(size.width*1.0554125,size.height*-0.5181500);
    path_0.lineTo(size.width*-0.0795875,size.height*-0.8881500);
    path_0.lineTo(size.width*-0.1145875,size.height*0.7018500);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


    // Layer 1 Copy

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(95, 56, 142, 60)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_1 = Path();
    path_1.moveTo(size.width*-0.1891754,size.height*1.1277191);
    path_1.quadraticBezierTo(size.width*-0.1947767,size.height*1.4894995,size.width*0.2016057,size.height*0.6212264);
    path_1.cubicTo(size.width*0.4145034,size.height*0.2077006,size.width*0.4191875,size.height*1.1999000,size.width*0.9793500,size.height*0.8707000);
    path_1.quadraticBezierTo(size.width*1.3235875,size.height*0.4958500,size.width*1.1594390,size.height*0.0867030);
    path_1.lineTo(size.width*1.0300515,size.height*-0.0098527);
    path_1.lineTo(size.width*-0.1526943,size.height*-0.3548535);
    path_1.lineTo(size.width*-0.1891754,size.height*1.1277191);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

