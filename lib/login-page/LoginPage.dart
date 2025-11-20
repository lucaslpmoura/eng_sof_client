import 'dart:convert';


import 'package:eng_sof_client/utils/ReqClient.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage(this.client);

  ReqClient client;

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
            onPressed: () => login(context),
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

  void login(BuildContext context) async{
    var response;
    try{
      response = await client.login(emailController.text, passwordController.text);
    }catch(e){
      response = ReqResponse(false, 500, "Couldn't communicate with server!");
    }
    

    SnackBar snackBar = SnackBar(
      content: Text(response.message), 
      duration: const Duration(seconds: 4), 
      backgroundColor:  response.ok ? Colors.green : Colors.red
    );
  
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if(response.ok){
      Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamed('mainPage');
    }
  }

}