
import 'package:flutter/material.dart';
import 'package:ManageMe/theme.dart';
import 'package:ManageMe/Services/ManagerServices.dart';
import 'package:intl/intl.dart';
import 'package:ManageMe/Services/UserServices.dart';
import 'package:ManageMe/Services/DateServices.dart';
import 'ListOfBuildings.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: must_be_immutable
class BillManagement extends StatefulWidget {
  var building;
  var buildingID;
  var writeAccess;
  BillManagement({Key key, @required this.building,@required this.buildingID,@required this.writeAccess}) : super(key: key);
  @override
  _BillManagementState createState() => _BillManagementState(building: building,buildingID: buildingID,writeAccess: writeAccess);
}

// request to delete bill
Future<String> deleteBill(String uid, String billID,String buildingID) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/deleteBill?uid="+uid+"&buildingID="+buildingID+"&billID="+billID));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future getAllBuildingUnpaidBills(building) async{
  var bills = [];
  var billsIDs = building["billsID"];
  for(int i = 0; i < billsIDs.length;i++){
    await ManagerServices.getBillInfo(billsIDs[i]).then((bill){
       bills.add(bill);
    });
  }
  print(bills);
  return bills;
}

String getWeekday(int n){
  var dayLst = ["الاثنين","الثلاثاء","الاربعاء","الخميس","الجمعة","السبت","الاحد"];
  return dayLst[n-1];
}

class _BillManagementState extends State<BillManagement> {
  var writeAccess;
  var building;
  var buildingID;
  var _bills = [];
  _BillManagementState({Key key, @required this.building,@required this.buildingID,@required this.writeAccess});
  @override
  void initState() {
    getAllBuildingUnpaidBills(building).then((bills){
      setState(() {
        _bills = bills;
      });
    });
    super.initState();
  }
  Widget showPeople(List<dynamic> uids, String text){
    return RaisedButton(
      child: Text(text,textAlign: TextAlign.right,),
      color: Colors.white,
      onPressed: (){
        UserServices.getUserName(uids).then((names){
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(text,textAlign: TextAlign.right,),
                content: Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0, // Change as per your requirement
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(names[index],textAlign: TextAlign.right,),
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("أغلق"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الفواتير غير المسددة"),
        backgroundColor: AppTheme.appbarColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          (_bills.length == 0)?Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),))
              :Column(
          children: _bills
                  .map((element) =>
          (element["usersWhoPaid"].length == element["users"].length)?
          Container():
          new Padding(
                padding: EdgeInsets.all(20),
                child: new Container(
                  padding: EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(5),),
                                new Text(element["label"].toString(),style: TextStyle(fontSize: 20),),
                                Padding(padding: EdgeInsets.all(5),),
                                Text("المبلغ المستحق لكل مشارك"),
                                (element["Currency"]== 'USD') ? new Text(new NumberFormat("###,###.0#", "en_US").format(element["amount"]).toString()+ " "+ element["Currency"],textAlign: TextAlign.right,style: TextStyle(fontSize: 15,color: Colors.grey),)
                                    : new Text(new NumberFormat("###,###", "en_US").format(element["amount"]).toString()+ " "+ element["Currency"]+ " "+": المبلغ المستحق",textAlign: TextAlign.right,style: TextStyle(fontSize: 15,color: Colors.grey),),
                                Row(
                                  children: <Widget>[
                                    showPeople(element["users"],"المشاركين"),
                                    showPeople(element["usersWhoPaid"],"الدافعين"),
                                  ],
                                ),
                                new MaterialButton(
                                  child: new Text("المزيد من المعلومات",textAlign: TextAlign.right,),
                                  onPressed: (){
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: new Text("المزيد من المعلومات",textAlign: TextAlign.right,),
                                          content: Container(
                                            // Change as per your requirement
                                            child: Text(element["description"],textAlign: TextAlign.right,),
                                          ),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new FlatButton(
                                              child: new Text("أغلق"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                (writeAccess)?MaterialButton(
                                  child: Text("حذف",style: TextStyle(color: Colors.red),),
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: new Text("حذف",textAlign: TextAlign.right,),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new FlatButton(
                                              child: new Text("لا"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new FlatButton(
                                              child: new Text("نعم"),
                                              onPressed: () {
                                          FirebaseAuth.instance.currentUser().then((user){
                                            deleteBill(user.uid, element["uid"], buildingID).then((r){
                                              print(r);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return new BuildingsList();
                                                },
                                              ));
                                            });
                                          });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ):Container()
                              ],
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text(DateServices.getMonthName((new DateTime(int.parse(element["dueTime"].split("|")[2]),int.parse(element["dueTime"].split("|")[0]),int.parse(element["dueTime"].split("|")[1]),0,0,0,0)).month),
                                  style: TextStyle(fontSize: 20),),
                                new Text(getWeekday((new DateTime(int.parse(element["dueTime"].split("|")[2]),int.parse(element["dueTime"].split("|")[0]),int.parse(element["dueTime"].split("|")[1]),0,0,0,0)).weekday),
                                  style: TextStyle(fontSize: 20),),
                                new Text((new DateTime(int.parse(element["dueTime"].split("|")[2]),int.parse(element["dueTime"].split("|")[0]),int.parse(element["dueTime"].split("|")[1]),0,0,0,0)).day.toString(),
                                  style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ))
                  .toList()),
        ],
      ),
    );

  }
}
