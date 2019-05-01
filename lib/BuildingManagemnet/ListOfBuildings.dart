import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'BuildingManagemnet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CreateBuilding.dart';
import 'package:ManageMe/theme.dart';

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




class BuildingsListState extends State<BuildingsList> {
  var _allBuildings = [];
  var _allBuildingsIDs = [];
  var currentPressed;
  var currentPressedID;
  var uid ="";
  bool _isLoading = false;
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
          _isLoading = true;
          _allBuildings =tuple.item1;
          _allBuildingsIDs = tuple.item2;
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
        backgroundColor: AppTheme.appBarBackgroundColor,
      ),
        backgroundColor: AppTheme.backgroundColor,
      body:(!_isLoading)? Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)):
        ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton.extended(
              elevation: 0.0,
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new CreateBuilding();
                  },
                ));
              },
              icon: Icon(Icons.add,color: AppTheme.textOne,),
              label: new Text('إنشاء مبنى',style: TextStyle(color: Color.fromRGBO(101, 127, 172, 1)),),
            ),
          ),
          Column(
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
        ],
      )
    );
  }

  
}
