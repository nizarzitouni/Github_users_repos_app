import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_users_app/screens/repositories_page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _query = '';
  final TextEditingController _queryUsersTextEditingController =
      TextEditingController();
  // bool _visible = false;
  dynamic bodyDataRes;
  int currentPage = 0;
  int totalPage = 0;
  int pageSize = 20;
  List<dynamic> usersList = [];
  ScrollController scrollController = ScrollController();

  void _findUser(String query) async {
    final http.Response response = await http
        .get(Uri.parse(
            'https://api.github.com/search/users?q=$_query&per_page=$pageSize&page=$currentPage'))
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        bodyDataRes = jsonDecode(response.body);
        //adding old data to a list
        usersList.addAll(bodyDataRes['items']);
        if (bodyDataRes["total_count"] % pageSize == 0) {
          totalPage = bodyDataRes["total_count"] ~/ pageSize;
        } else {
          totalPage = (bodyDataRes["total_count"] / pageSize).floor() + 1;
        }
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('................Failed to load Users................');
    }
  }

  Future getResponse() async {
    var result = await http.get(Uri.parse(
        'https://api.github.com/search/users?q=$_query&per_page=20&page=0'));
    return result;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPage - 1) {
            _findUser(_query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search for : $_query P $currentPage / $totalPage',
          style: TextStyle(fontSize: 15),
        ),
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      // onChanged: ((value) {
                      //   setState(() {
                      //     _query = value;
                      //   });
                      // }),
                      //obscureText: _visible,
                      controller: _queryUsersTextEditingController,
                      decoration: InputDecoration(
                          //icon: Icon(Icons.logout),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  // _visible = !_visible;
                                  _queryUsersTextEditingController.text = '';
                                });
                              },
                              icon:
                                  _queryUsersTextEditingController.text.isEmpty
                                      ? Container()
                                      : Icon(Icons.close)),
                          contentPadding: const EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.deepPurple),
                          )),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _query = _queryUsersTextEditingController.text;
                      _findUser(_query);
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: getResponse(),
                builder: (context, userListSnapshot) {
                  if (userListSnapshot.connectionState ==
                      ConnectionState.done) {
                    return Container(
                      child: ListView.separated(
                        separatorBuilder: ((context, index) => Divider(
                              height: 2,
                              color: Colors.deepPurple,
                            )),
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RepositoriesPage(
                                        login: usersList[index]["login"],
                                        avatarImageUrl: usersList[index]
                                            ["avatar_url"],
                                        score: usersList[index]["score"],
                                        emailUrl: usersList[index]["url"],
                                      )));
                            },
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${usersList[index]["avatar_url"]}"),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("${usersList[index]["login"]}"),
                              ],
                            ),
                            trailing: CircleAvatar(
                              child: Text("${usersList[index]["score"]}"),
                            ),
                          );
                        },
                        itemCount: bodyDataRes == null ? 0 : usersList.length,
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
