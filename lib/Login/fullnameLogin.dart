import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ManageMe/homeNavigation.dart';
import 'package:ManageMe/User.dart';




class FullName extends StatefulWidget{
  @override
  _FullName createState() => new _FullName();
  }

class _FullName extends State<FullName>{
  String fullname;

  void SetName(){

    FirebaseAuth.instance.currentUser().then((user){
      User initializeUser  = new User(this.fullname, user.uid, [], user.phoneNumber, "", "", "", false);
      initializeUser.updateAllInfoInDatabase();
    });

    Navigator.of(context).pop();
    Navigator.push(this.context, new MaterialPageRoute(
        builder: (context) =>
        new Nav())
    );


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child:Text("Full Name",style: TextStyle(fontSize: 30, color: Colors.white),),
            ),
            
            TextField(
              decoration: InputDecoration(
                fillColor: Color.fromRGBO(66, 85, 156, 1),
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                enabledBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(66, 85, 156, 1),width: 0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
              onChanged: (value) {
                if(value.length > 0){
                  this.fullname = value;
                }

              },
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              child:
              RaisedButton(
                  onPressed: () => SetName(),
                  child: Text('Submit',style: TextStyle(color: Colors.white),),
                  textColor: Colors.white,
                  elevation: 7.0,
                  color: Color.fromRGBO(66, 85, 156, 1),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              ),
            ),
          ],
        ) ,
      )
    );

  }
}
