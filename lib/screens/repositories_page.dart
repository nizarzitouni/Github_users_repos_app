import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'widgets/card_widget.dart';

class RepositoriesPage extends StatefulWidget {
  RepositoriesPage({
    required this.login,
    required this.avatarImageUrl,
    required this.score,
    required this.emailUrl,
  });
  String login;
  String avatarImageUrl;
  double score;
  String emailUrl;
  @override
  State<RepositoriesPage> createState() => _RepositoriesPageState();
}

class _RepositoriesPageState extends State<RepositoriesPage> {
  dynamic bodyDataRes;

  @override
  void initState() {
    super.initState();
    _loadRpositories();
  }

  void _loadRpositories() async {
    String url = "https://api.github.com/users/${widget.login}/repos";
    final _response = await http.get(Uri.parse(url));
    if (_response.statusCode == 200) {
      setState(() {
        bodyDataRes = jsonDecode(_response.body);
      });
    } else {
      throw Exception('................Failed to load Users................');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'), //of ${widget.login}
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.avatarImageUrl,
                scale: 25,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CustomCard(
            imageUrl: widget.avatarImageUrl,
            scoreNb: widget.score,
            userNameLogin: widget.login,
            emailUrl: widget.emailUrl,
          ),
          Expanded(child: reposList()),
        ],
      ),
    );
  }

  Widget reposList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${bodyDataRes[index]["name"]}"),
        );
      },
      separatorBuilder: ((context, index) => Divider(
            height: 2,
            color: Colors.deepPurple,
          )),
      itemCount: bodyDataRes == null ? 0 : bodyDataRes.length,
      scrollDirection: Axis.vertical,
    );
  }
}
