import 'dart:convert';
import 'dart:ui';

import 'package:eng_sof_client/main-page/Post.dart';
import 'package:eng_sof_client/main-page/PostList.dart';
import 'package:eng_sof_client/utils/ReqClient.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage(this.client);

  ReqClient client;
  @override
  State<MainPage> createState() => _MainPageState(client);
}

class _MainPageState extends State<MainPage> {
  _MainPageState(this.client) {
    updatePostList();
  }

  ReqClient client;
  List<Post> posts = [];

  MainPageState state = MainPageState.LOADING;

  BuildContext? currentContext;

  void updatePostList() {
    if(mounted){
         setState(() {
            state = MainPageState.LOADING;
            posts = [];
        });
    }
    try {
        client.getPosts().then((response) async {
            MainPageState newState;
            List<Post> postList = [];

            if (response.ok) {
            newState = MainPageState.LOADED;
            var posts = jsonDecode(jsonDecode(response.message))['posts'];
            postList = await toPostList(posts);
            } else {
            newState = MainPageState.FAILED_TO_LOAD;
            }

            setState(() {
            state = newState;
            posts = postList;
            });
        });
        } catch (exception) {
        setState(() {
            state = MainPageState.FAILED_TO_LOAD;
            posts = [];
        });
        }
  }

  @override
  Widget build(BuildContext context) {

    currentContext = context;

    return Scaffold(
      body: body(),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPostWindow(context),
        tooltip: 'New Post',
        child: Icon(Icons.post_add),
      ),
      appBar: AppBar(
        title: const Text("The Social Network"),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(), 
            icon: const Icon(Icons.menu), 
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
              ),
              onTap: () => _logout(),
            )
          ],
        ),
      ),
    );
  }

  Widget body() {
    switch (state) {
      case MainPageState.LOADED:
        return PostList(posts, client, updatePostList);
      case MainPageState.FAILED_TO_LOAD:
        return Center(child: Text("Failed to load posts!"));
      case MainPageState.LOADING:
      default:
        return Center(child: const CircularProgressIndicator());
    }
  }

  Future<void> _openPostWindow(context) {
    TextEditingController postController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                controller: postController,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                client.makePost(postController.text);
                setState(() {
                  state = MainPageState.LOADING;
                  posts = [];
                });
                updatePostList();
                Navigator.of(context).pop();
              },
              child: const Text("Post"),
            ),
          ],
        );
      },
    );
  }

  Future<List<Post>> toPostList(dynamic list) async{
    List<Post> postList = [];
    for (var item in list) {
      var response = await client.getUserInfo(item['author_id']);
      var userInfo = jsonDecode(jsonDecode(response.message))['userInfo'];
      postList.add(
        Post(
          item['u_id'],
          item['createdtime'],
          item['p_content'],
          userInfo['u_id'],
          userInfo['username'],
          userInfo['email']
        ),
      );
    }
    return postList;
  }

  void _logout(){
    client.token = '';
    client.userId = '';

    Navigator.of(currentContext!).pushReplacementNamed('loginPage');
  }
}

enum MainPageState { LOADING, LOADED, FAILED_TO_LOAD }
