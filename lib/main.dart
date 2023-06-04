import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '/views/loginPage.dart';
import 'constanst.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() {
    runApp(const MyApp());
}


class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: LoginPage(),
        theme: CustomDarkTheme.darkTheme,
        // theme: CustomDarkTheme.darkTheme,
        // darkTheme:CustomDarkTheme.darkTheme,
      );
    }
}
