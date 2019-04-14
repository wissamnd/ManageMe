import 'package:flutter/material.dart';
import 'package:ManageMe/Objects/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login/Logger.dart';
import 'package:ManageMe/Objects/User.dart';
import 'theme.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';



class HomeScreen extends StatefulWidget {


  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  DateTime _initialDate;
  static var _amountDue = 0;
  String _currency = "LBP";


  @override
  void initState() {
    super.initState();
    _initialDate = DateTime.now();
      FirebaseAuth.instance.currentUser().then((user){
        getUserBuilding(user.uid).then((amount){
          setState(() {
            _amountDue = amount;
          });
        });
      });


  }
  Future getUserBuilding(String uid) async {
    var amount = 0;
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
    var valueMap = json.decode(result.body);
    var buildingIDs = valueMap["buildings"].cast<String>();
    for(var i = 0; i < buildingIDs.length;i++){
      await getAmountOfBills(uid, buildingIDs[i], _initialDate.month, _initialDate.year).then((number){
        amount += number;
      });
    }
    return amount;
  }

  // parse the list of bills in the building
  Future getAmountOfBills(String uid,String buildingID,int month, int year) async {
    var amount = 0;
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyMonthlyBuildingBills?uid='+uid+'&buildingID='+buildingID+'&month='+month.toString()+'&year='+year.toString());
    var valueMap = json.decode(result.body);
    for(var i = 0 ; i < valueMap.length;i++){
      if(valueMap[i]["usersWhoPaid"].indexOf(uid) < 0){
        if(valueMap[i]["Currency"]== 'USD'){
          amount = amount + (valueMap[i]["amount"]*1500);
        }else{
          amount = amount + valueMap[i]["amount"];
        }
      }
    }
    return amount;
  }
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
                              Text("المبلغ المستحق",style: TextStyle(fontSize: 30, color:Color.fromRGBO(101, 127, 172, 1).withOpacity(0.5), ),),
                              Text(new NumberFormat("###,###", "en_US").format(_amountDue).toString(),style: TextStyle(fontSize: 40,color:Color.fromRGBO(101, 127, 172, 1)), ),
                              Text(_currency,style: TextStyle(fontSize: 20,color:Color.fromRGBO(101, 127, 172, 1)), ),
                              new Padding(padding: EdgeInsets.all(5)),
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






getCurrentMonth(){
  var monthLst = ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران', 'تموز',
  'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'];
  var now = DateTime.now();
  return monthLst[now.month - 1];
}





