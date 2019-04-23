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
  var _error = false;
  String _currency = "LBP";
  String statusText = "..."+"جار التحميل";
  String errorText = "أعد التحميل من فضلك";


  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
      FirebaseAuth.instance.currentUser().then((user){
        UserServices.getUserTotalDueBillsInAllBuildingsLBP(user.uid, _currentDate.month, _currentDate.year).then((amount){
          setState(() {
            _amountDue = amount;
            _loading = false;
            _error = false;
          });
        }).catchError((e){
          setState(() {
            _error = true;
          });
        });
      });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            MaterialButton(
              child: new Tooltip(message: "إعادة تحميل",child: new Icon(Icons.refresh,color: Colors.white),),
              onPressed: (){
                setState(() {
                  statusText = "..."+"جار التحميل";
                  _loading = true;
                });
                FirebaseAuth.instance.currentUser().then((user){
                  UserServices.getUserTotalDueBillsInAllBuildingsLBP(user.uid, _currentDate.month, _currentDate.year).then((amount){
                    setState(() {
                      _amountDue = amount;
                      _loading = false;
                      _error = false;
                    });
                  }).catchError((e){
                    setState(() {
                      _error = true;
                    });
                  });
                });
              },
            )
          ],
            title:Text(' خلاصة شهر '+ DateServices.getMonthName(_currentDate.month),),
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
                              Text(statusText,style:TextStyle(fontSize: 30,color:AppTheme.textOne),textAlign: TextAlign.right,)
                                  : Text(new NumberFormat("###,###", "en_US").format(_amountDue).toString(),style: TextStyle(fontSize: 40,color:AppTheme.textOne), ),
                              (!_loading)?Text(_currency,style: TextStyle(fontSize: 20,color:AppTheme.textOne), ):Container(),
                              new Padding(padding: EdgeInsets.all(5)),
                              (_error)?Center(
                                child:
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: new BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(errorText,style: TextStyle(color: Colors.white),),
                                ),
                              ):Container()
                            ],
                          )
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}











