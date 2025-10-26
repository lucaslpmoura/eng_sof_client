import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:eng_sof_client/constants/constants.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
    var client = http.Client();
    var uri = Uri.http(SERVER_ADDR, REGISTER_ENDPOINT);

    var response = await client.post(
      uri, 
      headers: <String,String> {'Content-Type': 'application/json'},
      body: jsonEncode(<String,String>{
        'username': usernameController.text,
        'email': emailController.text, 
        'password': passwordController.text}));


    var message = jsonDecode(response.body)['message'];

    if(response.statusCode == 200){
      var snackbar = SnackBar(content: Text(message + ". Returning to the main page."), duration: Duration(seconds: 3),); 
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushNamed('loginPage');
    }else{
      var snackbar = SnackBar(content: Text(message), duration: Duration(seconds: 4),); 
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

}