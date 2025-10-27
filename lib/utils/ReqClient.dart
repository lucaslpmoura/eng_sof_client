import 'dart:convert';

import 'package:eng_sof_client/constants/constants.dart';
import 'package:http/http.dart' as http;

class ReqClient {
  var client;
  String token = '';
  String userId = '';

  ReqClient() {
    client = http.Client();
  }

  Future<ReqResponse> login(String email, String password) async {
    var uri = Uri.http(SERVER_ADDR, LOGIN_ENDPOINT);
    var response = await client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      token = jsonDecode(response.body)['token'];
      userId = jsonDecode(response.body)['userId'];
    }

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      jsonDecode(response.body)['message'],
    );
  }

  Future<ReqResponse> register(
    String username,
    String email,
    String password,
  ) async {
    var uri = Uri.http(SERVER_ADDR, REGISTER_ENDPOINT);

    var response = await client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      jsonDecode(response.body)['message'],
    );
  }

  Future<ReqResponse> getPosts() async {
    var uri = Uri.http(SERVER_ADDR, FEED_ENDPOINT);

    var response = await client.get(
      uri,
      headers: <String, String>{'auth': token},
    );

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      jsonEncode(response.body),
    );
  }

  Future<ReqResponse> makePost(String content) async {
    var uri = Uri.http(SERVER_ADDR, FEED_ENDPOINT);

    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth': token,
      },
      body: jsonEncode(<String, String>{'content': content}),
    );

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      jsonEncode(response.body),
    );
  }

  Future<ReqResponse> deletePost(String postId) async {
    var uri = Uri.http(SERVER_ADDR, FEED_ENDPOINT, {'id': postId});

    var response = await client.delete(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth': token,
      },
      body: jsonEncode(<String, String>{}),
    );

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      response.body,
    );
  }

  Future<ReqResponse> getUserInfo(String userId) async {
    var uri = Uri.http(SERVER_ADDR, REGISTER_ENDPOINT, {'id': userId});

    var response = await client.get(
      uri,
      headers: <String, String>{'auth': token},
    );

    return ReqResponse(
      response.statusCode == 200,
      response.statusCode,
      jsonEncode(response.body),
    );
  }
}

class ReqResponse {
  ReqResponse(this.ok, this.status, this.message);

  bool ok;
  int status;
  String message;
}
