import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/screens/splashscreen.dart';
import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Apis(),
        ),
      ],
      child: Consumer<Apis>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color.fromRGBO(56, 14, 63, 1),
            canvasColor: Colors.grey.shade200,
            fontFamily: 'Avenir',
          ),
          home: const SplashScreen(),
          routes: {
            '/home': (context) => HomeScreen(),
            NavigationScreen.routeName: (context) => const NavigationScreen()
          },
        ),
      ),
    );
  }
}
