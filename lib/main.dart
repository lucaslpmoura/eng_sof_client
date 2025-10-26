import 'package:eng_sof_client/login-page/LoginPage.dart';
import 'package:eng_sof_client/register-page/RegisterPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eng. Sof. - Social Network',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      initialRoute: 'loginPage',
      routes: {
        'loginPage': (context) => LoginPage(),
        'registrationPage': (context) => RegisterPage()
      }
    );
  }
}

