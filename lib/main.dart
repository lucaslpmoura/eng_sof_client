import 'package:eng_sof_client/login-page/LoginPage.dart';
import 'package:eng_sof_client/main-page/MainPage.dart';
import 'package:eng_sof_client/register-page/RegisterPage.dart';
import 'package:eng_sof_client/utils/ReqClient.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ReqClient client = ReqClient();

  Color canvasColor = Color.fromARGB(255, 36, 36, 36);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eng. Sof. - Social Network',
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        dialogTheme: DialogThemeData(backgroundColor: canvasColor),
        scaffoldBackgroundColor: canvasColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: 'loginPage',
      routes: {
        'loginPage': (context) => LoginPage(client),
        'registrationPage': (context) => RegisterPage(client),
        'mainPage': (context) => MainPage(client),
      },
    );
  }
}
