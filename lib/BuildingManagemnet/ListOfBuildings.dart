import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import 'BuildingManagemnet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CreateBuilding.dart';

class BuildingsList extends StatefulWidget {
  @override
  BuildingsListState createState() => BuildingsListState();
}


// get all the building that the user is a tenant in
Future getUserBuildings(String uid) async {
  var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
  var userInfoMap = json.decode(result.body);
  var buildingIDs = userInfoMap["buildings"].cast<String>(); // these are the building IDs for the tenant
  var allBuildings = [];
  for(var i = 0; i < buildingIDs.length;i++){
    var resultTwo = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyBuildingInfo?uid='+uid+'&buildingID='+buildingIDs[i]);
    var buildingsInfoMap = json.decode(resultTwo.body);
    allBuildings.add(buildingsInfoMap);
  }

  var t =  Tuple2(allBuildings, buildingIDs);
  return t;
}

// get the total number of bills for a specific building given its id
Future getTotalBills(String uid,String buildingID) async {
  DateTime now = DateTime.now();
  var month = now.month;
  var year =  now.year;
  var total = 0;
  var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyMonthlyBuildingBills?uid='+uid+'&buildingID='+buildingID+'&month='+month.toString()+'&year='+year.toString());
  var listOfBills = json.decode(result.body);
  for(var i = 0; i < listOfBills.length;i++ ){
    total =  total + await ( listOfBills[i]["amount"] * listOfBills[i]["users"].length) ;
  }
  return total;

}

// return a map with each building name and corresponding bills amount
Future getBuildingTotalAmountOfBills(String uid,List buildingsID,List buildings)async{
  Map currentBillsTotalMap = {};
   for(var i =0; i < buildingsID.length;i++){
    await getTotalBills(uid, buildingsID[i]).then((number){
      currentBillsTotalMap[buildings[i]["buildingName"]] =  number ;
    });
  }
  return currentBillsTotalMap;
}

// display all amount of bills for each building
Widget displayCurrentBillsText(Map currentBillsMap, buildingName,String currency){

  if(currency == "USD"){
    return (currentBillsMap.length >0 )?Text( new NumberFormat("###,###.#", "en_US").format(currentBillsMap[buildingName]).toString() + " \$"):Text("");
  }else{
    return (currentBillsMap.length >0 )?Text(new NumberFormat("###,###", "en_US").format(currentBillsMap[buildingName]).toString()+ "  L.L"):Text("");
  }

}



class BuildingsListState extends State<BuildingsList> {
  var _allBuildings = [];
  var _allBuildingsIDs = [];
  Map _currentBillsTotalMap = {};
  var currentPressed;
  var currentPressedID;
  var uid ="";
  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();

  void accessDeniedSnackBar() {
    final snackBar = new SnackBar(content: new Text('غير مسموح بالدخول :أنت لست رئيس المبنى ',textAlign: TextAlign.right,));
    mScaffoldState.currentState.showSnackBar(snackBar);
  }
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        uid = user.uid;
      });
      getUserBuildings(user.uid).then((tuple){
        setState(() {
          _allBuildings =tuple.item1;
          _allBuildingsIDs = tuple.item2;
        });
        getBuildingTotalAmountOfBills(user.uid, tuple.item2, tuple.item1).then((map){
          setState(() {
            _currentBillsTotalMap =map;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mScaffoldState,
      appBar: AppBar(
        title: Text("البنايات"),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      ),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body:(_allBuildings.length ==0)? Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)):
        ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                children: _allBuildings
                    .map((building) =>
                new Padding(
                  padding: EdgeInsets.all(10),
                  child: MaterialButton(
                    onPressed: (){
                        setState(() {
                          currentPressed = building;
                          currentPressedID = _allBuildingsIDs[_allBuildings.indexOf(building)];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuildingManagement(pBuilding: building,pBuildingID: currentPressedID,),)
                        );

                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                (building["manager"]==uid)?Icon(Icons.perm_identity):Text(""),
                              Text(building["buildingName"],style: TextStyle(fontSize: 20),textAlign: TextAlign.right,),
                              Text("عدد السكان: "+ building["tenantsUID"].length.toString(),style: TextStyle(fontSize: 15),textAlign: TextAlign.right,),
                              Text("شاغر:" + (building["numberofApartments"]- building["tenantsUID"].length).toString(),style: TextStyle(color: Colors.grey),textAlign: TextAlign.right,),
                              Padding(padding: EdgeInsets.all(5),),
                              Text(" قيمة الفواتير الحالية",style: TextStyle(fontSize: 15),textAlign: TextAlign.right,),
                              displayCurrentBillsText(_currentBillsTotalMap, building["buildingName"],building["Currency"])

                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10),),
                          new Image.asset('images/skyline.png', width: 120.0, height: 120.0),
                        ],
                      ),
                    ),
                  ),
                ))
                    .toList()),
          ),
          Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child:new RaisedButton(
                      child: new Text('إنشاء مبنى'),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new CreateBuilding();
                          },
                        ));
                      },
                    ),
                  ),

                ],
              )
          ),
        ],
      )
    );
  }

  
}
