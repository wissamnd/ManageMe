import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:ManageMe/homeNavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'NewUser.dart';
import 'package:ManageMe/Services/ConnectivityServices.dart';


class Logger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {

  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final Firestore _db = Firestore.instance;
  String countryCode;
  String phoneNo;
  String smsCode;
  String verificationId;
  String error = "";



  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(this.context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                  signIn();
                },
              )
            ],
          );
        });
  }
  signIn() {

    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
      DocumentReference ref = _db.collection("users").document(user.uid);
      ref.get().then((doc){
        Navigator.pop(context);
        if(!doc.exists){
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) =>
              new NewUser())
          );
        }else{
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) =>
              new Nav())
          );
        }

      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: new Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: ListView(

              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(50.0),
                  child: new Center(
                    child: new Image.asset('images/Logo.png'),
                  ),
                ),
                Container(
                  height: 100,
                  child: Text("ابدأ الآن", textAlign: TextAlign.center,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: Colors.white),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CountryCodePicker(
                      onChanged: (countryCode){
                        this.countryCode = countryCode.toString();
                      },
                      initialSelection: 'LB',
                      favorite: ['+961','LB'],
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width *0.56,
                      child:TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            fillColor: Color.fromRGBO(66, 85, 156, 1),
                            hintText: "Enter phone number",
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
                          this.phoneNo = countryCode + value;
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(error),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child:
                  RaisedButton(
                      onPressed: (){
                        ConnectivityServices.checkConnection().then((internet){
                          if(internet != null && internet){
                            verifyPhone();
                            setState(() {
                              error = "";
                            });
                          }else{
                            setState(() {
                              error = "Error please connect to the internet";
                            });

                          }
                        });
                        },
                      child: Text('Verify',style: TextStyle(color: Colors.white),),
                      textColor: Colors.white,
                      elevation: 7.0,
                      color: Color.fromRGBO(66, 85, 156, 1),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  ),
                ),
              ],
            )),
      ),
    );
  }
}











