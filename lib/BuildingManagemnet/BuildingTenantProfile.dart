import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:io';
import 'ListOfBuildings.dart';
import 'package:firebase_auth/firebase_auth.dart';
class BuildingTenantProfile extends StatefulWidget {
  var tenantInfo;
  var writeAccess;
  var building;


  BuildingTenantProfile({Key key, @required this.tenantInfo,@required this.writeAccess,@required this.building}) : super(key: key);
  @override
  _BuildingTenantProfileState createState() => _BuildingTenantProfileState(tenantInfo: tenantInfo,writeAccess: writeAccess,building: building);
}

Future<String> markAsPaid(String uid, String buildingID, String tenantUID,String billID) async {
  Map jsonMap = {
    "user" : tenantUID
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.patchUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/MarkAsPaid?uid="+uid+"&buildingID="+buildingID+"&billID="+billID));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> sendAMessage(String uid, String buildingID, String tenantUID,String message) async {
  Map jsonMap = {
    "message" : message
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.patchUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/SendAMessage?uid="+uid+"&tenantUID="+tenantUID+"&buildingID="+buildingID));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future getListOfBills(String uid,String buildingName) async {
  var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyBuildingBills?uid='+uid+'&buildingID='+buildingName);
  var valueMap = json.decode(result.body);
  return valueMap;
}
// request to delete Tenant
Future<String> deleteTenant(String uid, String buildingID, String tenantUID) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/RemoveTennat?uid="+uid+"&buildingID="+buildingID+"&tenantUID="+tenantUID));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}
// display the date given a number
Widget displayCurrentAmount(double amount, String currency){

  if(currency == "USD"){
    return Text( new NumberFormat("###,###.#", "en_US").format(amount).toString() + " \$",);
  }else{
    return Text(new NumberFormat("###,###", "en_US").format(amount).toString()+ "  L.L",);
  }

}




String getWeekday(int n){
  var dayLst = ["الاثنين","الثلاثاء","الاربعاء","الخميس","الجمعة","السبت","الاحد"];
  return dayLst[n-1];
}

Widget displayDate(String date){
  return Column(
    children: <Widget>[
      new Text(getWeekday((new DateTime(int.parse(date.split("|")[2]),int.parse(date.split("|")[0]),int.parse(date.split("|")[1]),0,0,0,0)).weekday),
        style: TextStyle(fontSize: 20),),
      new Text((new DateTime(int.parse(date.split("|")[2]),int.parse(date.split("|")[0]),int.parse(date.split("|")[1]),0,0,0,0)).day.toString(),
        style: TextStyle(fontSize: 20),),
      
    ],
  );
}

class _BuildingTenantProfileState extends State<BuildingTenantProfile> {
  var tenantInfo;
  var writeAccess;
  var building;
  var _listOfBills = [];
  bool _timeout = false;
  TextEditingController _messageController =new TextEditingController();




  _BuildingTenantProfileState({Key key, @required this.tenantInfo,@required this.writeAccess,@required this.building});
  @override
  void initState() {
    getListOfBills(tenantInfo["uid"], building).then((list){
      setState(() {
        _listOfBills =list;
      });
    });
    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _timeout = true;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        title: Text(tenantInfo["fullName"]),
      ),
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20),),
          (writeAccess)?MaterialButton(
            padding: EdgeInsets.all(10),
            child: Text("إزالة من المبنى",style: TextStyle(color: Colors.red,),),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("إزالة من المبنى",textAlign: TextAlign.right,),
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
                            if(user.uid != tenantInfo["uid"]){
                              deleteTenant(user.uid, building, tenantInfo["uid"]);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return new BuildingsList();
                                },
                              ));
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              );
              // call on delete request

            },
          ):Container(),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(tenantInfo["photo"]),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),),
          (writeAccess)?Center(

            child: MaterialButton(
                child: Icon(Icons.message,color: Colors.white,),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("ارسل رسالة",textAlign: TextAlign.right,),
                        content: new TextField(
                          textAlign: TextAlign.right,
                          controller: _messageController,
                        ),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          new FlatButton(
                            child: new Text("تجاهل"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text("إرسال"),
                            onPressed: () {
                              if(_messageController.text.length > 0){
                                FirebaseAuth.instance.currentUser().then((user){
                                  sendAMessage(user.uid, building, tenantInfo['uid'], _messageController.text).then((r){
                                    print(r);
                                  });
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

            )
          ):Container(),
          Padding(padding: EdgeInsets.all(20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(tenantInfo["phonenumber"],style: TextStyle(color: Colors.white))),
              Text("رقم الهاتف",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,)
            ],
          ),

          (tenantInfo["email"].length != 0)?Padding(padding: EdgeInsets.all(20),):Container(),
          (tenantInfo["email"].length != 0)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(tenantInfo["email"],style: TextStyle(color: Colors.white))),
              Text("البريد الإلكتروني",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,)
            ],
          ):Container(),
          (tenantInfo["about"].length != 0)?Padding(padding: EdgeInsets.all(20),):Container(),
          (tenantInfo["about"].length != 0)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child:Text(tenantInfo["about"],style: TextStyle(color: Colors.white)),
              ),
              Text("معلومة اضافية",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,)
            ],
          ):Container(),
          Padding(padding: EdgeInsets.all(20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (tenantInfo["traveling"])?Text("نعم",style: TextStyle(color: Colors.white)):Text("لا",style: TextStyle(color: Colors.white)),
              Text("مسافر",style: TextStyle(color: Colors.white))
            ],
          ),
          Padding(padding: EdgeInsets.all(20),),
          Divider(color: Colors.white,),
          Center(
            child: Text("الفواتير المستحقة",style: TextStyle(color: Colors.white,fontSize: 30),textAlign: TextAlign.right,),
          ),
          Padding(padding: EdgeInsets.all(10),),
          (_listOfBills.length == 0)?(_timeout)?(Center(child: Text("لا توجد فواتير مستحقة",textAlign: TextAlign.right,))):LinearProgressIndicator():Column(
            children: _listOfBills.map((bill)=>
              (!bill["usersWhoPaid"].contains(tenantInfo["uid"]))?
              Padding(
                padding: EdgeInsets.all(10),
                  child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          displayDate(bill["dueTime"]),
                          Text(bill["label"],),
                          displayCurrentAmount(double.parse(bill["amount"].toString()), bill["Currency"]),
                        ],
                      ),
                      (writeAccess)?RaisedButton(
                        color: Color.fromRGBO(101, 127, 172, 1),
                        child: Text("اجعله مدفوعًا",style: TextStyle(color:Colors.white),),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("اجعله مدفوعًا",textAlign: TextAlign.right,),
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
                                        markAsPaid(user.uid, building, tenantInfo["uid"], bill["uid"]).then((s){
                                          print(s);
                                          setState(() {
                                            _listOfBills.remove(bill);
                                          });
                                          Navigator.of(context).pop();
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
                  )
              )):
              Container(),
            ).toList(),
            
          )
        ],
      ),
    );
  }
}
