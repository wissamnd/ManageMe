import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'BuildingTenantProfile.dart';


class BuildingTenants extends StatefulWidget {
  var tenantsIDs;
  var building;
  bool writeAccess;
  BuildingTenants({Key key, @required this.tenantsIDs,@required this.writeAccess,@required this.building}) : super(key: key);
  @override
  _BuildingTenantsState createState() => _BuildingTenantsState(tenantsIDs: tenantsIDs,writeAccess: writeAccess,building: building);
}


Future getUsersInformation(List uids) async {
  var listOfInfo = [];
  for(var i = 0;i< uids.length;i++){
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uids[i]);
    var valueMap = await json.decode(result.body);
    listOfInfo.add(valueMap);
  }
  return listOfInfo;
}

class _BuildingTenantsState extends State<BuildingTenants> {
  var tenantsIDs;
  bool writeAccess;
  var building;
  var _listOfInfo = [];
  _BuildingTenantsState({Key key, @required this.tenantsIDs,@required this.writeAccess,@required this.building});
  @override
  void initState() {
    getUsersInformation(tenantsIDs).then((list){
      setState(() {
        _listOfInfo = list;
      });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سكان المبنى"),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      ),
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10)),
          (_listOfInfo.length == 0)? Center(child:CircularProgressIndicator()):
          Column(
              children: _listOfInfo.map((tenant)=>
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new BuildingTenantProfile(tenantInfo: tenant, writeAccess: writeAccess,building:building);
                          },
                        ));
                    },
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child:Container(
                          padding: EdgeInsets.all(20),
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(Radius.circular(20))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(tenant["photo"]),
                              ),
                              Text(tenant["fullName"]),
                            ],
                          ),
                        )),
                  ),
              ).toList()
          )
        ],
      ),
    );
  }
}
