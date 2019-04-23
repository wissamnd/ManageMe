import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'ListOfBuildings.dart';

class CreateBuilding extends StatefulWidget{

  @override
  _CreateBuilding createState() => _CreateBuilding();
}







class _CreateBuilding extends State<CreateBuilding> {
  bool _lbp = true;
  String buildingName = "";
  String address = "";
  int apartments = 0;
  String error = "";
  TextEditingController _buildingNameController= new TextEditingController();
  TextEditingController _buildingAddressController = new TextEditingController();
  TextEditingController _buildingApartmentsController = new TextEditingController();


  Future<String> createABuildingRequest(String uid) async {

    var currency = '';
    if(_lbp){
      currency = 'LBP';
    }else{
      currency = 'USD';
    }
    Map jsonMap = {
      "address": _buildingAddressController.text,
      "buildingName": _buildingNameController.text,
      "Currency": currency,
      "numberofApartments": int.parse(_buildingApartmentsController.text)
    };
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/CreateABuilding?uid="+uid));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print(reply);
    return reply;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("إنشاء بناية جديدة",style: TextStyle(fontSize: 20,color: Colors.white),),
            backgroundColor: Color.fromRGBO(101, 127, 172, 0.5),
        ),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        body:Container(
            padding: EdgeInsets.all(10),
            child:ListView(
              children: <Widget>[
                new Container(
                    child: Center(
                      child: new Column(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(10)),
                          new Text('إسم البناية',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                          new Padding(padding: EdgeInsets.all(10)),
                          new Directionality(
                            textDirection: TextDirection.rtl,
                            child:new TextField(
                              controller: _buildingNameController,
                              textAlign: TextAlign.right,
                              decoration: new InputDecoration(
                                hintText: "أدخل الإسم هنا",
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                enabledBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white,width: 1),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                ),
                new Container(
                    child: new Column(
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(10)),
                        new Text('العنوان',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                        new Padding(padding: EdgeInsets.all(10)),
                        new Directionality(
                          textDirection: TextDirection.rtl,
                          child: new TextFormField(
                            controller: _buildingAddressController,
                            textAlign: TextAlign.right,
                            decoration: new InputDecoration(
                              hintText: "أدخل العنوان هنا",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              enabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                new Container(
                    child: new Column(
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(10)),
                        new Text('عدد الشقق',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 15),),
                        new Padding(padding: EdgeInsets.all(10)),
                        new TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                            controller: _buildingApartmentsController,
                            textAlign: TextAlign.center,
                            decoration: new InputDecoration(
                              hintText: "أدخل عدد الشقق هنا",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              enabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),

                      ],
                    )
                ),
                new Padding(padding: EdgeInsets.all(10)),
                new Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new RaisedButton(
                          child: const Text('LBP',),
                          color: _lbp ? Colors.white : Color.fromRGBO(101, 127, 172, 1),
                          elevation: 4.0,
                          splashColor: Colors.white,
                          onPressed: () {
                            if(_lbp == false){
                              setState(() {
                                _lbp = true;
                              });
                            }
                          },
                        ),
                        new RaisedButton(
                          child: const Text('USD'),
                          color: _lbp ?  Color.fromRGBO(101, 127, 172, 1) :Colors.white,
                          elevation: 4.0,
                          splashColor: Colors.white,

                          onPressed: (
                              ) {
                            if(_lbp== true){
                              setState(() {
                                _lbp = false;
                              });

                            }

                          },
                        ),

                      ],
                    )
                ),
                new Padding(padding: EdgeInsets.all(10)),
                new RaisedButton(
                  child: const Text('إنشاء',style: TextStyle(fontSize: 15),),
                  color: Colors.white,
                  elevation: 4.0,
                  splashColor: Color.fromRGBO(101, 127, 172, 1),
                  onPressed: () {
                    if(_buildingNameController.text.length>0 && _buildingAddressController.text.length >0 && int.parse(_buildingApartmentsController.text) >0){
                      setState(() {
                        error = "";
                      });
                      FirebaseAuth.instance.currentUser().then((user){
                        createABuildingRequest(user.uid).then((r){
                          print(r);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                            builder: (BuildContext context) {
                              return new BuildingsList();
                            },
                          ));
                        });
                      });

                    }else{
                      setState(() {
                        error = "الرجاء إدخال الحقول المفقودة";
                      });
                    }
                  },
                ),
                Center(
                  child: Text(error),
                ),
              ],
            )
        )
    );
  }
}










