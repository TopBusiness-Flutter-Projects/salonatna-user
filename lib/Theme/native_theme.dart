import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(255, 166, 146, .1),
  100: const Color.fromRGBO(255, 166, 146, .2),
  200: const Color.fromRGBO(255, 166, 146, .3),
  300: const Color.fromRGBO(255, 166, 146, .4),
  400: const Color.fromRGBO(255, 166, 146, .5),
  500: const Color.fromRGBO(255, 166, 146, .6),
  600: const Color.fromRGBO(255, 166, 146, .7),
  700: const Color.fromRGBO(255, 166, 146, .8),
  800: const Color.fromRGBO(255, 166, 146, .9),
  900: const Color.fromRGBO(255, 166, 146, 1),
};
ThemeData nativeTheme() {
  return ThemeData(
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xFFFA692C), selectionHandleColor: Color(0xFFFA692C)),
    splashFactory: NoSplash.splashFactory,
    primaryColor: const Color(0xFFFA692C),
    primaryColorLight: const Color(0xFF898A8D), // Color(0xFF66d5ff),
    primaryColorDark: const Color(0xFFFA692C),
    primaryIconTheme: const IconThemeData(color: Color(0xFFFA692C)),
    cardColor: Colors.white,
    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500), // listtile title white
      displayMedium: TextStyle(color: Colors.white70, fontSize: 11), // listtile subtitle white
      displaySmall: TextStyle(fontSize: 14, color: Color(0xFF171D2C), fontWeight: FontWeight.w500), // signup / signin
      headlineMedium: TextStyle(fontSize: 30, color: Color(0xFF171D2C), letterSpacing: -0.5, fontWeight: FontWeight.bold), // signup && sign in
      headlineSmall: TextStyle(fontSize: 15, color: Color(0xFFFA692C), fontWeight: FontWeight.w400), // - homeScreen - orange
      titleLarge: TextStyle(fontSize: 15, color: Color(0xFF171D2C), fontWeight: FontWeight.w600), //-  home Screen
      titleMedium: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400), // listtile subtitle
      titleSmall: TextStyle(fontSize: 14, color: Color(0xFF565656), fontWeight: FontWeight.w600), // Listtile title
      bodySmall: TextStyle(fontSize: 25, color: Color(0xFF171D2C), fontWeight: FontWeight.bold), // verify, reset, forgot pwd,
      labelSmall: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600), // book appoinments

      labelLarge: TextStyle(fontSize: 13.5, color: Color(0xFF565656), fontWeight: FontWeight.w600),

      bodyLarge: TextStyle(
        fontSize: 13,
        color: Color(0xFF171D2C),
        fontWeight: FontWeight.w500,
      ), // home screen
      bodyMedium: TextStyle(fontSize: 12, color: Color(0xFF898A8D), fontWeight: FontWeight.w400), // home screen
    ),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFA692C),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.grey[100],
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFA692C)),
    ),
    fontFamily: 'Poppins',
    dividerColor: Colors.transparent,
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,      
      height: 50,
      buttonColor: Color(0xFFFA692C),
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      disabledColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: const EdgeInsets.all(0),
      shadowColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    disabledColor: Colors.grey,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(8),
      alignLabelWithHint: true,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: Color(0xFF898A8D),
        fontWeight: FontWeight.w400,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(width: 0.2, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: const Color(0xFF898A8D).withOpacity(0.2)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFA692C)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      filled: true,
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF171D2C),
      selectedIconTheme: IconThemeData(color: Color(0xFFFA692C), size: 26),
      unselectedIconTheme: IconThemeData(color: Color(0xFF898A8D), size: 26),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Color(0xFF171D2C), size: 30),
      iconTheme: IconThemeData(color: Color(0xFF171D2C), size: 30),
      titleTextStyle: TextStyle(fontSize: 17, color: Color(0xFF171D2C), fontWeight: FontWeight.w600), systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color(0xFFFA692C),
        ),
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
      backgroundColor: WidgetStateProperty.all(const Color(0xFFFA692C)),
      shadowColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      )),
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)),
    )),
    iconTheme: const IconThemeData(color: Color(0xFF898A8D)),

    tabBarTheme: const TabBarTheme(
      labelPadding: EdgeInsets.only(bottom: 3),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontSize: 13.5, color: Color(0xFF171D2C), fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 13.5, color: Color(0xFF898A8D), fontWeight: FontWeight.w400),
    ),

    bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFF171D2C)),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xFF171D2C), contentTextStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400), behavior: SnackBarBehavior.fixed), colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xFFFA692C, color)).copyWith(secondary: Colors.red),
  );
}
