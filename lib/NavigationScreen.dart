
import 'package:flutter/material.dart';
import 'package:ManageMe/BuildingManagemnet/CreateBuilding.dart';
import 'BillsList.dart';
import 'BuildingManagemnet/BuildingManagemnet.dart';
import 'BuildingManagemnet/ListOfBuildings.dart';
import 'Notifications.dart';
import 'userAccount.dart';


class NavigationScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,60,20,10),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  onPressed: (){
//                    Navigator.of(context).push(new MaterialPageRoute(
//                      builder: (BuildContext context) {
//                        return new BillsList();
//                      },
//                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.calendar_today,size: 60,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("التقارير",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.right,)

                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new UserAccount();
                      },
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.perm_identity,size: 60,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("الحساب",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.right,)

                    ],
                  ),
                )

              ],
            ),
            Padding(padding: EdgeInsets.all(20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new BillsList();
                      },
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.monetization_on,size: 60,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("الفواتير",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.right,)

                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new Notifications();
                      },
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.notifications,size: 60,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("الإشعارات",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.right,)

                    ],
                  ),
                )

              ],
            ),
            Padding(padding: EdgeInsets.all(20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return BuildingsList();
                      },
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child:new Image.asset('images/skyline.png', width: 60.0, height: 60.0),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("البنايات",style: TextStyle(fontSize: 20,color: Colors.white),)

                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (){
//                    Navigator.of(context).push(new MaterialPageRoute(
//                      builder: (BuildContext context) {
//                        return new BillsList();
//                      },
//                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(120)),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.settings,size: 60,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      Text("الإعدادات",style: TextStyle(fontSize: 20,color: Colors.white),)

                    ],
                  ),
                )

              ],
            ),

          ],
        ),
      )


    );
  }
}