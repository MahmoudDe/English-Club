import 'dart:ui';

import 'package:bdh/widgets/start_screen/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';

import '../widgets/start_screen/form_widget.dart';

class StartScreen extends StatefulWidget {
  static const String routName = '/start-screen';
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  // ignore: deprecated_member_use
  Locale appLocale = window.locale;
  bool isMenuOpen = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    // Check the user's scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 50), curve: Curves.easeIn);
      setState(() {
        isMenuOpen = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50), curve: Curves.easeIn);
      setState(() {
        isMenuOpen = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    animationController.forward();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(52, 3, 80, 1),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              SizedBox(
                width: mediaQuery.width,
                height: mediaQuery.height / 1.08,
                child: const Image(
                  image: AssetImage('assets/images/auth.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: mediaQuery.height / 1.7,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(50),
                      topEnd: Radius.circular(50),
                    ),
                    color: Colors.white),
                child: FormStartWidget(
                    mediaQuery: mediaQuery,
                    scrollController: _scrollController,
                    isMenuOpen: isMenuOpen),
              )
            ],
          ),
          TextWidget(
              isMenuOpen: isMenuOpen,
              mediaQuery: mediaQuery,
              animation: _animation),
          isMenuOpen
              ? const SizedBox(
                  height: 0,
                )
              : Positioned(
                  bottom: 10,
                  right: 150,
                  left: 150,
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                      setState(() {
                        isMenuOpen = true;
                      });
                    },
                    child: Lottie.asset(
                      'assets/lotties/scroll.json',
                    ),
                  )),
        ],
      ),
    );
  }
}
