import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Notifications extends StatefulWidget{

  @override
  _Notifications createState() {
    return _Notifications();
  }
}

class _Notifications extends State<Notifications>{
  List<String> _messages = [];

  void setUserMessages(String uid) async {
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
    var valueMap = json.decode(result.body);
    setState(() {
      _messages = valueMap["messages"].cast<String>();
    });
  }

  @override
  void initState() {
      super.initState();
      FirebaseAuth.instance.currentUser().then((user){
        setUserMessages(user.uid);
      });

  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(101, 127, 172, 1),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("تبليغات",),
              ],
            )
          ),
          backgroundColor: Color.fromRGBO(101, 127, 172, 1),
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