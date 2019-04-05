import 'package:flutter/material.dart';




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
                          new Text('إسم البناية',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                          new Padding(padding: EdgeInsets.all(10)),
                          new Directionality(
                            textDirection: TextDirection.rtl,
                            child:new TextFormField(
                              controller: _buildingNameController,
                              textAlign: TextAlign.right,
                              decoration: new InputDecoration(
                                labelText: "أدخل الإسم هنا",
                                fillColor: Colors.blueAccent,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                //fillColor: Colors.green
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
                              labelText: "أدخل العنوان هنا",
                              fillColor: Colors.blueAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                    color: Colors.white
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
                        new Text('عدد الشقق',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                        new Padding(padding: EdgeInsets.all(10)),
                        new TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                            controller: _buildingApartmentsController,
                            decoration: new InputDecoration(
                              fillColor: Colors.blueAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                    color: Colors.white
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
                      Navigator.of(context).pop();
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










