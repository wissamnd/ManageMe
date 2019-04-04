import 'package:flutter/material.dart';
import 'package:ManageMe/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login/Logger.dart';
import 'User.dart';
import 'theme.dart';



class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Center(
              child: Text(' خلاصة شهر '+ getCurrentMonth()),
            ),
          backgroundColor: AppTheme.appbarColor ,
        ),

        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        body:Container(
            child:Column(
              children: <Widget>[
                Dash(),
              ],
            )
        )
    );
  }
}



class Dash extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Center(
            child: new Stack(
              children: <Widget>[
                new Container(
                  width: 300,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        offset: new Offset(0, 5.0),
                        blurRadius: 5.0,
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: (MediaQuery.of(context).size.width)/9.5,
                  top: (MediaQuery.of(context).size.height)/6,
                  child: Column(
                    children: <Widget>[
                      Text("الفاتورة",style: TextStyle(fontSize: 30, color:Color.fromRGBO(101, 127, 172, 1).withOpacity(0.5), ),),
                      Text("700,000 L.L",style: TextStyle(fontSize: 40,color:Color.fromRGBO(101, 127, 172, 1)), ),
                      Container(
                        child: new Text (
                            "+ 100,000 L.L",
                            style: new TextStyle(
                                color: Color.fromRGBO(101, 127, 172, 1),
                                fontWeight: FontWeight.w900
                            )
                        ),
                        decoration: new BoxDecoration (
                            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                            color: Color.fromRGBO(101, 127, 172, 0.5)
                        ),
                        padding: new EdgeInsets.fromLTRB(16.0, 9.0, 16.0, 9.0),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}

displaySnackBar(BuildContext context, String text){
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: "",
      onPressed: () {
        // Some code to undo the change!
      },
    ),
  );

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  Scaffold.of(context).showSnackBar(snackBar);
}

getCurrentMonth(){
  var monthLst = ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران', 'تموز',
  'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'];
  var now = DateTime.now();
  return monthLst[now.month - 1];
}





