
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'ListOfBuildings.dart';
import 'BuildingTenants.dart';
import 'AddTenant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BillManagemnet.dart';
import 'AddBill.dart';
class BuildingManagement extends StatefulWidget {
  final pBuilding;
  final pBuildingID;

  BuildingManagement({Key key, @required this.pBuilding,@required this.pBuildingID}) : super(key: key);
  @override
  _BuildingManagementState createState() => _BuildingManagementState(pBuilding: pBuilding,pBuildingID: pBuildingID);
}



Widget displayCurrentReservedText(double amount, String currency){

  if(currency == "USD"){
    return Text( new NumberFormat("###,###.#", "en_US").format(amount).toString() + " \$",);
  }else{
    return Text(new NumberFormat("###,###", "en_US").format(amount).toString()+ "  L.L",);
  }

}

// request to delete building
Future<String> deleteBuilding(String uid, String buildingID) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/deleteBuilding?uid="+uid+"&buildingID="+buildingID));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> editReserved(String uid, String buildingID, double amount) async {
  Map jsonMap = {
    "reserved" : amount
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.patchUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/updateBuildingReserved?uid="+uid+"&buildingID="+buildingID));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}



class _BuildingManagementState extends State<BuildingManagement> {
  var pBuilding;
  final pBuildingID;
  bool writeAccess = false;
  double _reserved =0.0;
  TextEditingController reservedController = new TextEditingController();
  _BuildingManagementState({@required this.pBuilding,@required this.pBuildingID});
  @override
  void initState() {
    super.initState();
    _reserved = double.parse(pBuilding["reserved"].toString());
    FirebaseAuth.instance.currentUser().then((user){
      if(pBuilding["manager"] == user.uid){
        setState(() {
          writeAccess = true;
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(pBuilding["buildingName"]),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      ),
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20),),
            Center(
              child:new Image.asset('images/skyline.png', width: 150.0, height: 150.0),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(pBuilding["address"],textAlign: TextAlign.right,style: TextStyle(color: Colors.white),),
                  new Icon(Icons.location_on,color: Colors.white,),
                ],
              )
            ),
            Padding(padding: EdgeInsets.all(20),),
            Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child:new RaisedButton(
                        child: new Text('سكان المبنى'),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BuildingTenants(tenantsIDs: pBuilding["tenantsUID"],writeAccess: writeAccess,building:pBuildingID);
                          },
                        ));
                        },
                      ),
                    ),

                  ],
                )
            ),
            Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child:new RaisedButton(
                        child: new Text('الفواتير غير المسددة'),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,

                        onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new BillManagement(building: pBuilding,buildingID: pBuildingID,writeAccess: writeAccess,);
                          },
                        ));
                        },
                      ),
                    ),

                  ],
                )
            ),
            (writeAccess)?Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child:new RaisedButton(
                        child: new Text('إضافة مقيم'),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new AddTenant(building: pBuildingID,);
                          },
                        ));
                        },
                      ),
                    ),

                  ],
                )
            ):Container(),
            (writeAccess)?Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child:new RaisedButton(
                        child: new Text('أضف فاتورة'),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new AddBill(building: pBuilding,buildingID: pBuildingID,);
                          },
                        ));
                        },
                      ),
                    ),

                  ],
                )
            ):Container(),
            Padding(padding: EdgeInsets.all(30)),
            Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("احتياطي الطوارئ"),
                  displayCurrentReservedText(_reserved, pBuilding["Currency"]),
                  (writeAccess)?MaterialButton(
                    padding: EdgeInsets.only(left:1),
                    child:Icon(Icons.edit),
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => new AlertDialog(
                            title: Text("تغيير احتياطي الطوارئ",textAlign: TextAlign.end,),
                            content: new TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              controller: reservedController,
                              maxLength: 20,
                              textAlign: TextAlign.end,
                            ),
                            actions: <Widget>[
                              new MaterialButton(child: Text("تقديم",),onPressed: (){
                                if(reservedController.text != null){
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _reserved = double.parse(reservedController.text);
                                  });
                                  FirebaseAuth.instance.currentUser().then((user){
                                    editReserved(user.uid, pBuildingID, double.parse(reservedController.text));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return new BuildingsList();
                                      },
                                    ));
                                  });

                                }
                              })
                            ],

                          ) );
                    },
                  ):Text(""),
                ],
              )
            ),
            Padding(padding: EdgeInsets.all(20)),
            (writeAccess)?MaterialButton(
              padding: EdgeInsets.all(10),
              child: Text("إزالة المبنى",style: TextStyle(color: Colors.red,),),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("إزالة المبنى",textAlign: TextAlign.right,),
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
                              deleteBuilding(user.uid, pBuildingID).then((r){
                                print(r);
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
                // call on delete request
              },
            ):Container(),
          ],
        ),
      ),
    );
  }
}
