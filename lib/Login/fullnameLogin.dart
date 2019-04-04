import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ManageMe/homeNavigation.dart';
import 'package:ManageMe/User.dart';
import 'package:ManageMe/UserServices.dart';
import 'package:connectivity/connectivity.dart';




class FullName extends StatefulWidget{
  @override
  _FullName createState() => new _FullName();
}

class _FullName extends State<FullName>{
  String fullName;
  String error = "";

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void SetName(){

    FirebaseAuth.instance.currentUser().then((user){
      User initializeUser  = new User(this.fullName, user.uid, [], user.phoneNumber, "", "", "", false);
      initializeUser.updateAllInfoInDatabase();
    });

    Navigator.pushReplacement(this.context, new MaterialPageRoute(
        builder: (context) =>
        new Nav())
    );


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(title: Text("fullname"),),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child:Text("Welcome to ManageMe",style: TextStyle(fontSize: 30, color: Colors.white),),
              ),

              new Padding(padding: EdgeInsets.all(20)),

              TextField(
                style: new TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                maxLength: 28,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Full Name",
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
                  this.fullName = value;
                },
              ),
              Text(error,style: TextStyle(color: Colors.white70,fontStyle: FontStyle.italic),),
              Container(
                padding: EdgeInsets.only(top: 50),
                child:
                RaisedButton(
                    onPressed: (){
                      check().then((internet){
                        if(internet != null && internet){

                          if((fullName !=null) && (fullName.length > 0) ){
                            setState(() {
                              this.error = "";
                              SetName();
                            });
                          }else{
                            print("please enter a name");
                            setState(() {
                              this.error = "please enter a name";
                            });
                          }

                        }else{
                          print("You have no internet connection");
                          setState(() {
                            this.error = "You have no internet connection";
                          });
                        }
                      });

                    },
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
