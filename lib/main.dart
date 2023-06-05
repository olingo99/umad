import 'package:flutter/material.dart';
import '/views/loginPage.dart';
import 'constanst.dart';


void main() {
    runApp(const MyApp());
}


class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: const LoginPage(),
        theme: CustomDarkTheme.darkTheme,
      );
    }
}
