import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login/Logger.dart';
import 'User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserServices.dart';
import 'Building.dart';
import 'Bill.dart';
import 'theme.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile> {

  static User currentUser = User.instance();
  static bool isLoading = true;
  List<String> litems = ["Example","Hello","This is a buidling","Hi","This"];


  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val) {
        UserServices.getCurrentUserInfo(val.uid).then((user){
          setState(() {
            currentUser = user;
          });
        }).whenComplete((){
          setState(() {
            isLoading = false;
          });
        });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoading){
      return Scaffold(
          backgroundColor: Color.fromRGBO(101, 127, 172, 1),
          body: ListView(
            children: <Widget>[
              new Center(
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: new Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage("https://www.w3schools.com/howto/img_avatar.png"),
                        radius: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: new Text('Hello, '+ currentUser.fullName,style: TextStyle(color: Colors.white,fontSize: 20),),
                      ),

                      new Text('Your phone number is '+currentUser.phoneNumber),
                      new Text('Your Current Building is '+currentUser.buildings.toString()),
//                new Text(currentUser.toString()),

                      SizedBox(
                        height: 15.0,
                      ),
                      new OutlineButton(
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid, width: 3.0),
                        child: Text('Logout'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((action) {
                            Navigator.pushReplacement(context, new MaterialPageRoute(
                                builder: (context) =>
                                new LoginPage())
                            );
                          }).catchError((e) {
                            print(e);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              new ListView.builder
                (
                  shrinkWrap: true,
                  itemCount: litems.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(litems[index]);
                  }
              ),
            ],
          ),
      );
    }else{
      return new Scaffold(
        body:new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppTheme.circularIndicators),
                ),
              ]
          ) ,
        )

      );
    }


  }


}
