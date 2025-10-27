import 'dart:convert';

import 'package:eng_sof_client/main-page/Post.dart';
import 'package:eng_sof_client/utils/ReqClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PostList extends StatelessWidget {
  PostList(this.posts, this.client, this._deletePostCallback);

  List<Post> posts;
  ReqClient client;
  Function _deletePostCallback;

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty
        ? const Center(child: Text("No Posts!"))
        : ListView(
            children: posts
                .map(
                  (post) => Column(
                    children: [
                      const SizedBox(height: 25),
                      Center(
                        child: _PostWidget(post, client, _deletePostCallback),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                )
                .toList(),
          );
  }
}

class _PostWidget extends StatelessWidget {
  _PostWidget(this.post, this.client, this._deletePostCallback) {
    isAuthor = post.authorId == client.userId;
  }

  double width = 400;
  Post post;
  ReqClient client;
  bool isAuthor = false;

  Function _deletePostCallback;

  BuildContext? currentContext;

  @override
  Widget build(BuildContext context) {
    currentContext = context;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.black, width: 2),
      ),
      width: width,
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                Text("From: ${post.authorName} / ${post.authorEmail}"),
                Spacer(),
                Text("${_getTimeString(post.createdTime)}"),
              ],
            ),
          ),
          SizedBox(width: width, child: Text(post.content)),
          SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.black, width: 2),
            ),
            width: width,
            constraints: BoxConstraints(maxWidth: width),
            child: Row(children: _getPostOptions(post)),
          ),
        ],
      ),
    );
  }

  List<Widget> _getPostOptions(Post post) {
    var list = [
      IconButton(
        onPressed: () => {},
        icon: Icon(Icons.favorite_outline),
        tooltip: 'Like Post',
      ),
    ];

    if (isAuthor) {
      list.add(
        IconButton(
          onPressed: () => {_openDeletePostDialog()},
          icon: Icon(Icons.delete_outline),
          tooltip: 'Delete Post',
        ),
      );
    }

    return list;
  }

  Future<void> _openDeletePostDialog() {
    return showDialog(
      context: currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var response = await client.deletePost(post.id);
                _deletePostCallback();
               
                SnackBar snackBar = SnackBar(
                  content: Text(jsonDecode(response.message)['message']),
                  duration: const Duration(seconds: 4),
                  backgroundColor: response.ok ? Colors.green : Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if(response.ok){
                  Navigator.of(context).pop();
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  String _getTimeString(String timestamp) {
    var postData = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp),
    ).millisecondsSinceEpoch;
    var now = DateTime.now().millisecondsSinceEpoch;

    var diff = now - postData;

    var minutes = (diff / 60000).round();
    var hours = (minutes / 60).round();
    var days = (hours / 24).round();

    if (minutes == 0) {
      return 'Just Now';
    }

    if (hours == 0) {
      return "${minutes} minutes ago";
    }

    if (days == 0) {
      return "${hours} hours ago";
    }

    return "${days} days ago";
  }
}
