import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:ManageMe/Services/UserServices.dart';
import 'theme.dart';

class Notifications extends StatefulWidget{

  @override
  _Notifications createState() {
    return _Notifications();
  }
}

class _Notifications extends State<Notifications>{
  List<String> _messages = [];
  @override
  void initState() {
      super.initState();
      FirebaseAuth.instance.currentUser().then((user){
        UserServices.getUserNotifications(user.uid).then((n){
          _messages = n;
          setState(() {
            _messages = _messages.reversed.toList().sublist(0,math.min(_messages.length -1, 15));
          });
        });
      });
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.appbarColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("الإشعارات",),
              ],
            )
          ),
          backgroundColor: AppTheme.backgroundColor,
          body: new ListView.builder
            (
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.all(20),
                    child:new Text(_messages[index],textAlign: TextAlign.right,),
                  ),
                );
              }
          ),
        );
  }
}