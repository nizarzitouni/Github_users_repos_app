import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  String imageUrl;

  double scoreNb;

  String userNameLogin;
  String emailUrl;

  CustomCard({
    Key? key,
    required this.imageUrl,
    required this.scoreNb,
    required this.userNameLogin,
    required this.emailUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.deepPurple,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                    // widget.avatarImageUrl,
                    //scale: 45,
                  ),
                  radius: 45,
                ),
                CircleAvatar(
                  child: Text('$scoreNb'),
                  radius: 25,
                ),
              ],
            ),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Username: $userNameLogin',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      Text("Github Link: $emailUrl",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
