import 'dart:convert';
import 'dart:io';


import 'package:eng_sof_client/utils/ReqClient.dart';
import 'package:flutter/material.dart';

import 'package:eng_sof_client/constants/constants.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  RegisterPage(this.client);

  ReqClient client;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: usernameController,
            textAlign: TextAlign.left,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back', textAlign: TextAlign.center)
            ),
            ElevatedButton(
              onPressed: () => register(context), 
              child: const Text('Register')
            )
            ],
          )
          
        ]
      )
    );
  }

  void register(BuildContext context) async{
    var response = await client.register(usernameController.text, emailController.text, passwordController.text);

    SnackBar snackBar = SnackBar(
      content: Text(response.message + (response.ok ? ". Redirecting to Login Page..." : "")), 
      duration: const Duration(seconds: 4), 
      backgroundColor:  response.ok ? Colors.green : Colors.red
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if(response.ok){
      Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushNamed('loginPage');
    }
  }

}