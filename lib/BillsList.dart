import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';
class BillsList extends StatefulWidget{

  @override
  _BillList createState() {
      return _BillList();
  }
}




class _BillList extends State<BillsList>{

  String _uid = "";      // the uid of the current user
  List<dynamic> _billItems = []; // the list of bills
  var initialDate = new DateTime.now();  // current date
  DateTime selectedDate;
  String _selectedBuildingID = "";
  String _selectedBuilding;
  List<String> _buildings = [];
  bool _isLoadingBuildings= true;
  List<String> _buildingsIDs = [""];

  // get user building Names
  void setUserBuildings(String uid) async {
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
    var valueMap = json.decode(result.body);
    var buildingIDs = valueMap["buildings"].cast<String>();
    setState(() {
      _buildingsIDs = valueMap["buildings"].cast<String>();
    });
    var allBuildingNames = [];
    for(var i = 0; i < buildingIDs.length;i++){
      var result2 = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyBuildingInfo?uid='+uid+'&buildingID='+buildingIDs[i]);
      var valueMap2 = json.decode(result2.body);
      allBuildingNames.add(valueMap2["buildingName"]);
    }
    setState(() {
      _buildings = allBuildingNames.cast<String>();
      _isLoadingBuildings = false;
    });
  }
  // Display a dialog of people
  Widget showPeople(List<dynamic> uids, String text){
    return RaisedButton(
      child: Text(text,textAlign: TextAlign.right,),
      color: Colors.white,
      onPressed: (){
        getUserName(uids).then((names){
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

  // parse the list of bills in the building
  void getListOffBills(String uid,String buildingName,int month, int year) async {
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyMonthlyBuildingBills?uid='+uid+'&buildingID='+buildingName+'&month='+month.toString()+'&year='+year.toString());
    var valueMap = json.decode(result.body);
    print(valueMap);
    setState(() {
      _billItems = valueMap;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = initialDate;
    _selectedBuilding = "";
    FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        _uid = user.uid;
      });
      setUserBuildings(user.uid);
    });


  }
  Widget getDate(){
    var monthLst = ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران', 'تموز',
    'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'];
    return Text(monthLst[selectedDate.month-1]);
  }
  String getWeekday(int n){
    var dayLst = ["الاثنين","الثلاثاء","الاربعاء","الخميس","الجمعة","السبت","الاحد"];
    return dayLst[n-1];
  }
   Future<List<String>>getUserName(List<dynamic> uids) async {
    List<String> names = [];
    for(int i = 0; i< uids.length;i++){
      var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uids[i]);
      var valueMap = await json.decode(result.body);
      names.add(await valueMap["fullName"]);
    }
    return names;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: new AppBar(
          backgroundColor: AppTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            getDate(),
            MaterialButton(
                child: Icon(Icons.calendar_today,color: Colors.white,),
                onPressed: (){
                  showMonthPicker(
                      context: context,
                      initialDate: selectedDate ?? initialDate)
                      .then((date) => setState(() {
                        if(date != null){
                          selectedDate = date;
                        }
                        if (_selectedBuilding.length != 0){
                          getListOffBills(_uid, _selectedBuildingID, selectedDate.month, selectedDate.year);
                        }
                  }));
                }),
          ],
        )
      ),
      body:
          ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 20,
                  child: (_isLoadingBuildings)?
                      new LinearProgressIndicator(
                      )
                      :
                        Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        color: Colors.white,
                      ),

                      child: Center(
                        child:new DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          hint: (_selectedBuilding.length != 0) ? Text(_selectedBuilding,style: TextStyle(fontSize: 20),textAlign: TextAlign.right,) : Text("يرجى اختيار المبنى",textAlign: TextAlign.right,style: TextStyle(fontSize: 20),),
                          items: _buildings.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedBuildingID = _buildingsIDs[_buildings.indexOf(val)];
                              _selectedBuilding = val;
                            });
                            getListOffBills(_uid, _selectedBuildingID, selectedDate.month, selectedDate.year);
                          },
                        ),
                      )
                  ),
                ),
              ),
              (_billItems.length == 0)? Text(""):
              // display the list of bills
              Container(
                child: Column(
                    children: _billItems
                        .map((element) => new Padding(
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
                                            // display if the bill is due or not
                                            (element["usersWhoPaid"].contains(_uid)) ?
                                            Container(
                                              padding: EdgeInsets.fromLTRB(30,5,30,5),
                                              decoration: new BoxDecoration(
                                                color: Color.fromRGBO(101, 127, 172, 1),
                                                borderRadius: new BorderRadius.circular(10.0),
                                              ),
                                              child: Text("دفع",style: TextStyle(color: Colors.white),),
                                            )
                                                : Container(
                                              padding: EdgeInsets.fromLTRB(30,5,30,5),
                                              decoration: new BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: new BorderRadius.circular(10.0),
                                              ),
                                              child: Text("مستحق",style: TextStyle(color: Colors.white),),
                                            ),
                                            Padding(padding: EdgeInsets.all(5),),
                                            new Text(element["label"].toString(),style: TextStyle(fontSize: 20),),
                                            Padding(padding: EdgeInsets.all(5),),
                                            (element["Currency"]== 'USD') ? new Text(new NumberFormat("###,###.0#", "en_US").format(element["amount"]).toString()+ " "+ element["Currency"]+ " "+": المبلغ المستحق",textAlign: TextAlign.right,style: TextStyle(fontSize: 15,color: Colors.grey),)
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
                                            )

                                          ],
                                        ),

                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
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
              ),
            ],
          )
    );

  }
}


