import 'userAccount.dart';
import 'package:flutter/material.dart';
import 'CreateBuilding.dart';
import 'theme.dart';
class NavigationScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child:new RaisedButton(
                      child: new Text('إدارة الملف الشخصي',style: TextStyle(color: AppTheme.textOne),),
                      textColor: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute<UserAccount>(
                          builder: (BuildContext context) {
                            return new UserAccount();
                          },
                        ));
                      },
                    ),
                  )

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
                      child: new Text('إنشاء مبنى',style: TextStyle(color: AppTheme.textOne),),
                      textColor: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute<UserAccount>(
                          builder: (BuildContext context) {
                            return new CreateBuilding();
                          },
                        ));
                      },
                    ),
                  )

                ],
              )
          ),

        ],
      )


    );
  }
}