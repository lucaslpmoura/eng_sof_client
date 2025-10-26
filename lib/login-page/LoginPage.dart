import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:eng_sof_client/constants/constants.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: emailController,
            textAlign: TextAlign.left,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: passwordController,
            textAlign: TextAlign.left,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          Row(children: [
            ElevatedButton(
            onPressed: () => login(),
            child: const Text('Login', textAlign: TextAlign.center)
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'registrationPage'), 
              child: const Text('Register')
            )
            ],
          )
          
        ]
      )
    );
  }

  void login() async{
    var client = http.Client();
    var uri = Uri.http(SERVER_ADDR, LOGIN_ENDPOINT);

    var response = await client.post(
      uri, 
      headers: <String,String> {'Content-Type': 'application/json'},
      body: jsonEncode(<String,String>{'email': emailController.text, 'password': passwordController.text}));
    print(response.body);
  }

}