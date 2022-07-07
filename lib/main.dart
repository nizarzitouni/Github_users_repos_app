import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/users_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => HomePage(),
        "/users": (context) => UsersPage(),
        //"/repositories": (context) => RepositoriesPage(),
      },
      //home: HomePage(),
      initialRoute: "/users",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
