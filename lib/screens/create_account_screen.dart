import 'package:flutter/material.dart';

import '../background/BackgroundPaint.dart';
import '../widgets/create_account_screen/form_widget.dart';

// import 'package:provider/provider.dart';

// ignore: camel_case_types
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _createAccountScreenState();
}

// ignore: camel_case_types
class _createAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(
                mediaQuery.width,
                (mediaQuery.width * 0.5833333333333334)
                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automaticallypainter: AppBarCustom(),
            painter: AppBarCustom(),
          ),
          FormCreatAccountWidget(mediaQuery: mediaQuery),
        ],
      ),
    );
  }
}
