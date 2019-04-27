import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'ListOfBuildings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ManageMe/Services/ManagerServices.dart';
import 'package:ManageMe/theme.dart';

// ignore: must_be_immutable
class AddTenant extends StatefulWidget{
 var building;
 AddTenant({Key key, @required this.building}) : super(key: key);
  @override
  _AddTenant createState() => _AddTenant(building: building);
}

class _AddTenant extends State<AddTenant> {
  String _error = "";
  String _countryCode ="";
  String _phoneNo="";
  var building;
  _AddTenant({Key key, @required this.building});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("إضافة السكان",style: TextStyle(fontSize: 20,color: Colors.white),),
        backgroundColor: AppTheme.appBarBackgroundColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20,150,20,20),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: new Text('أدخل الرقم',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CountryCodePicker(
                      onChanged: (countryCode){
                        _countryCode = countryCode.toString();
                      },
                      initialSelection: 'LB',
                      favorite: ['+961','LB'],
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width *0.5,
                      child:TextField(
                        onChanged: (value){
                          _phoneNo = _countryCode + value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(66, 85, 156, 1),
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(66, 85, 156, 1),width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(10)),
                new RaisedButton(
                  child: const Text('إضافة',style: TextStyle(fontSize: 15),),
                  color: Colors.white,
                  elevation: 4.0,
                  splashColor: Color.fromRGBO(101, 127, 172, 1),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {

                    if(_phoneNo.length >0){
                      FirebaseAuth.instance.currentUser().then((user){
                        ManagerServices.addATenant(user.uid, building, _phoneNo).then((r){
                          print(r);
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new BuildingsList();
                          },
                        ));
                      });
                    }else{
                      setState(() {
                        _error = "الرجاء إدخال الحقول المفقودة";
                      });
                    }
                  },
                ),
                Center(
                  child: Text(_error),
                ),

              ],
            ),
          ],
        )

      )
    );
  }
}