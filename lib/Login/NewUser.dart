import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ManageMe/homeNavigation.dart';
import 'package:ManageMe/Objects/User.dart';
import 'package:ManageMe/Services/ConnectivityServices.dart';



class NewUser extends StatefulWidget{
  @override
  _NewUser createState() => new _NewUser();
}

class _NewUser extends State<NewUser>{
  String fullName;
  String error = "";

  // initializing a new User
  void initializeNewUser(){
    FirebaseAuth.instance.currentUser().then((user){
      User initializeUser  = new User(this.fullName, user.uid, [], user.phoneNumber, "", "http://www.personalbrandingblog.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png", "", false,[]);
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
                  fullName = value;
                },
              ),
              Text(error,style: TextStyle(color: Colors.white70,fontStyle: FontStyle.italic),),
              Container(
                padding: EdgeInsets.only(top: 50),
                child:
                RaisedButton(
                    onPressed: (){
                      ConnectivityServices.checkConnection().then((internet){
                        if(internet != null && internet){

                          if((fullName !=null) && (fullName.length > 0) ){
                            setState(() {
                              error = "";
                              initializeNewUser();
                            });
                          }else{
                            print("please enter a name");
                            setState(() {
                              error = "please enter a name";
                            });
                          }

                        }else{
                          print("You have no internet connection");
                          setState(() {
                            error = "You have no internet connection";
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
