import 'package:flutter/material.dart';
import 'theme.dart';
class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("...قريبا",style: TextStyle(color: Colors.white,fontSize: 30),),
          )

        ],
      ),
    );
  }
}
