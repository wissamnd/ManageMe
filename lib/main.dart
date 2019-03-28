import 'dart:async';
import 'package:flutter/material.dart';
import 'homeNavigation.dart';
import 'Login/Logger.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  Logger log = new Logger();
  FirebaseAuth.instance.currentUser().then((user){
    if(user != null){
      runApp(new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(101, 127, 172, 1),
          accentColor: Color.fromRGBO(101, 127, 172, 1),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new Nav()
    },
      ));
    }else{
      runApp(new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(101, 127, 172, 1),
          accentColor: Color.fromRGBO(101, 127, 172, 1),
        ),
        debugShowCheckedModeBanner: false,
        home: log,
      ));
    }
  });
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Container(
        padding: EdgeInsets.all(50.0),
        child: new Center(
          child: new Image.asset('images/Logo.png'),
        ),
      )
      
    );
  }
}