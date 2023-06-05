import 'package:flutter/material.dart';


// class containing all the constants used in the app, makes it easier to change them
class Constants{

  // static const String API_URL = 'http://localhost:3000';
  // static const String API_URL = 'http://pat.infolab.ecam.be:60840';
  static const String API_URL = 'https://pat.infolab.ecam.be:64340';  //url of the API

  //Colors used in the app, not currently used as darktheme colors are used instead
  Color colorLink = const Color(0xFF0e131f);
  Color colorText = const Color(0xFFc8c8c8);
  Color colorBackground = const Color(0xFF30343f);
  Color colorButton = const Color(0xFFc03221);
  Color colorHover = const Color(0xCBc03121);
  Color colorTopbar = const Color(0xFF0e131f);
  Color colorSelected = const Color(0xFF614343);
}



//Create a custom dark theme for the app based on the built-in dark theme
class CustomDarkTheme{
  static final darkTheme = ThemeData.dark().copyWith(   //copy the dark theme with some modifications
  snackBarTheme: SnackBarThemeData(                    //change the color of the snackbar
    backgroundColor: Constants().colorBackground,
    contentTextStyle: const TextStyle(
      color: Colors.white,
    ),
    elevation: 20,
    actionTextColor: Constants().colorButton,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(         //change the style of the buttons
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
  );
}