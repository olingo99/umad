import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants{
  // static const String API_URL = 'http://localhost:3000';

  // static const String API_URL = 'http://pat.infolab.ecam.be:60840';
  static const String API_URL = 'https://pat.infolab.ecam.be:64340';


  Color colorLink = const Color(0xFF0e131f);
  Color colorText = const Color(0xFFc8c8c8);
  Color colorBackground = const Color(0xFF30343f);
  Color colorButton = const Color(0xFFc03221);
  Color colorHover = const Color(0xCBc03121);
  Color colorTopbar = const Color(0xFF0e131f);
  Color colorSelected = const Color(0xFF614343);





}


class CustomDarkTheme{



    static final darkTheme = ThemeData.dark().copyWith(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Constants().colorBackground,
      contentTextStyle: const TextStyle(
        color: Colors.white,
      ),
      elevation: 20,
      actionTextColor: Constants().colorButton,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants().colorButton,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    // colorScheme: ThemeData.dark().colorScheme.copyWith(background: Colors.red),
    // scaffoldBackgroundColor: Colors.red,
  );
}