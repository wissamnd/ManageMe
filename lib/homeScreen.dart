import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';
import 'package:intl/intl.dart';
import 'package:ManageMe/Services/UserServices.dart';
import 'package:ManageMe/Services/DateServices.dart';


class HomeScreen extends StatefulWidget {


  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate;
  static var _amountDue = 0;
  static var _loading = true;
  String _currency = "LBP";


  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
      FirebaseAuth.instance.currentUser().then((user){
        UserServices.getUserTotalDueBillsInAllBuildingsLBP(user.uid, _currentDate.month, _currentDate.year).then((amount){
          setState(() {
            _amountDue = amount;
            _loading = false;
          });
        });
      });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Center(
              child: Text(' خلاصة شهر '+ DateServices.getMonthName(_currentDate.month),)
            ),
          backgroundColor: AppTheme.appbarColor ,
        ),

        backgroundColor: AppTheme.backgroundColor,
        body:Center(
          child: Container(
            padding: EdgeInsets.only(top: 20),
              child:ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Container(
                          padding: EdgeInsets.all(80),
                          child: Column(
                            children: <Widget>[
                              Text("المبلغ المستحق",style: TextStyle(fontSize: 30, color:AppTheme.textOne.withOpacity(0.5), ),),

                              (_loading)?
                              CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.circularIndicators))
                                  : Text(new NumberFormat("###,###", "en_US").format(_amountDue).toString(),style: TextStyle(fontSize: 40,color:AppTheme.textOne), ),

                              Text(_currency,style: TextStyle(fontSize: 20,color:AppTheme.textOne), ),
                              new Padding(padding: EdgeInsets.all(5)),
//                              Container(
//                                  child: new Text (
//                                      "+ 100,000 L.L",
//                                      style: new TextStyle(
//                                          color: Color.fromRGBO(101, 127, 172, 1),
//                                          fontWeight: FontWeight.w900
//                                      )
//                                  ),
//                                decoration: new BoxDecoration (
//                                    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
//                                    color: Color.fromRGBO(101, 127, 172, 0.5)
//                                  ),
//                                  padding: new EdgeInsets.fromLTRB(16.0, 9.0, 16.0, 9.0),
//                              ),

                            ],
                          )
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}











