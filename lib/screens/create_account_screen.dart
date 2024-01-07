import 'package:flutter/material.dart';

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
          FormCreatAccountWidget(mediaQuery: mediaQuery),
        ],
      ),
    );
  }
}
