    import 'package:flutter/material.dart';
    import 'package:flutter/services.dart';
    import 'package:http/http.dart' show get;
    import 'dart:convert';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'ListOfBuildings.dart';
    import 'package:ManageMe/Services/ManagerServices.dart';
    import 'package:ManageMe/theme.dart';
    // ignore: must_be_immutable
    class AddBill extends StatefulWidget{
      var building;
      var buildingID;
      AddBill({Key key, @required this.building,@required this.buildingID}) : super(key: key);

      @override
      _AddBill createState() => _AddBill(buildingID: buildingID,building: building);
    }

    class _AddBill extends State<AddBill> {
     static List<String> tenants;

    String error="";
    bool repeat = false;
    int numberTenantsInBill=0;
    var building;               // current building
    var buildingID;       // current building ID
    var _tenantsNamesMap = {};
    var _tenantsNames = [];
    var _selectedTenants = [];
    DateTime _billDueDate = new DateTime.now();
    TextEditingController _billDescription= new TextEditingController();
    TextEditingController _billAmount = new TextEditingController();
    TextEditingController _billLabel= new TextEditingController();


    // initializes the state
    void _initializeState()async{
      var listOfTenantsUIDS = building["tenantsUID"];
      var tenantsNamesMap = {};
      var tenantsNames = [];
      for(var i= 0; i < listOfTenantsUIDS.length;i++){
        var result = await get(
            'https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid=' +
                listOfTenantsUIDS[i]);
        var valueMap = await json.decode(result.body);
        tenantsNames.add((await valueMap["fullName"]).toString());
        tenantsNamesMap[(await valueMap["fullName"]).toString()] = listOfTenantsUIDS[i];
      }
      setState(() {
        _tenantsNames= tenantsNames;
        _tenantsNamesMap =tenantsNamesMap;
      });
    }
     @override
     void initState() {
       _initializeState();
       super.initState();
     }

    // constructor
    _AddBill({Key key, @required this.building,@required this.buildingID});

      Future _selectDate() async {
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime(2019),
            lastDate: new DateTime(2030)
        );
        return picked;
      }


      @override

      Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: Text("إضافة فاتورة",style: TextStyle(fontSize: 20,color: Colors.white),),
           backgroundColor: AppTheme.appBarBackgroundColor,
         ),

         backgroundColor: AppTheme.appBarBackgroundColor,
         body: (_tenantsNames.length == 0)?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),) ,):
         Container(
           padding: EdgeInsets.all(10),
           child: ListView(
             children: <Widget>[

               Container(
                 padding: EdgeInsets.symmetric(vertical: 0,horizontal: 40),
                 child: new FloatingActionButton.extended(
                   icon: Icon(Icons.add,color: AppTheme.textOne,),
                   label: const Text(' المعنيين' ,style: TextStyle(fontSize: 15,color: Colors.black),),
                   backgroundColor: Colors.white,
                   elevation: 0.0,

                   onPressed: () {
                     showDialog (
                       context: context,
                       builder: (BuildContext context) {
                         // return object of type Dialog
                         return AlertDialog(
                           title: new Text('السكان',textAlign: TextAlign.right,),
                           content: DialogContent(tenantsNamesMap: _tenantsNamesMap, tenantsNames: _tenantsNames, selectedTenants: _selectedTenants),
                           actions: <Widget>[
                             // usually buttons at the bottom of the dialog
                             new Container(
                                 child: new Row(
                                   children: <Widget>[
                                     new FlatButton( child: new Text("موافق"),
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                       },
                                     ),
                                   ],
                                 )
                             )

                           ],
                         );
                       },
                     );

                   },
                 ),
               ),



               new Container(
                 padding: EdgeInsets.all(10),
                 child: Center(
                     child: new Column(
                       children: <Widget>[
                         new Text('التصنيف',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                         new Padding(padding: EdgeInsets.all(10)),
                         new Directionality(
                           textDirection: TextDirection.rtl,
                           child:new TextFormField(
                             controller: _billLabel,
                             textAlign: TextAlign.right,
                             decoration: new InputDecoration(
                               labelText: "أدخل التصنيف هنا",
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
                   padding: EdgeInsets.all(10),
                   child: new Column(
                     children: <Widget>[
                       new Padding(padding: EdgeInsets.all(10)),
                       new Text('المبلغ المستحق لكل مشارك',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                       new Padding(padding: EdgeInsets.all(10)),
                       new TextFormField(
                         textAlign: TextAlign.center,
                         keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                         controller: _billAmount,
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



               new Container(
                 padding: EdgeInsets.all(10),
                 child: Center(
                     child: new Column(
                       children: <Widget>[
                         new Text('المواصفات',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                         new Padding(padding: EdgeInsets.all(10)),
                         new Directionality(
                           textDirection: TextDirection.rtl,
                           child:new TextFormField(
                             inputFormatters: [
                               new LengthLimitingTextInputFormatter(100),
                             ],
                             controller: _billDescription,
                             textAlign: TextAlign.right,
                             maxLines: 3,
                             maxLength: 240,
                             decoration: new InputDecoration(
                               labelText: "أدخل المواصفات هنا",
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

               Center(child: new Text('المدة المحددة',textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),)),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   new Text(_billDueDate.day.toString()+ "/"+ _billDueDate.month.toString()+"/"+_billDueDate.year.toString(),textAlign: TextAlign.end,style: TextStyle(color: Colors.white,fontSize: 15),),
                   Container(
                     child: MaterialButton(
                         child: Icon(Icons.calendar_today,color: Colors.white,),
                         onPressed:(){
                           _selectDate().then((date){
                             setState(() {
                               if(date != null){
                                 _billDueDate = date;
                               }

                             });
                           });
                         }
                     ),
                   ),
                 ],
               ),

               new Container(
                 padding: new EdgeInsets.all(32.0),
                 child: new Center(
                     child: new Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Text("كرر لمدة 3 شهر",textAlign: TextAlign.right,style: TextStyle(color: Colors.white),),
                         new Checkbox(
                             value: repeat,
                             onChanged: (bool value){
                               setState(() {
                                 repeat = value;
                               });
                             }
                         )
                       ],
                     )
                 ),
               ),
               Center(
                 child: Text(error),
               ),
               new RaisedButton(
                 child: const Text('إضافة',style: TextStyle(fontSize: 15),),
                 color: Colors.white,
                 elevation: 4.0,
                 splashColor: Color.fromRGBO(101, 127, 172, 1),
                 onPressed: () {
                   if(_billLabel.text.length>0 && _billDescription.text.length>0 && int.parse(_billAmount.text) >0 && _selectedTenants.length>0){
                     setState(() {
                       error = "";
                     });
                     if(repeat){

                       FirebaseAuth.instance.currentUser().then((user){
                         ManagerServices.addABillRequestRepeat(user.uid, buildingID, int.parse(_billAmount.text), _billDescription.text, _billLabel.text, _selectedTenants,_billDueDate.month.toString()+"|"+
                             _billDueDate.day.toString()+"|"+_billDueDate.year.toString()).then((r){
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


                     }else{
                       // in case no repeat is pressed
                       FirebaseAuth.instance.currentUser().then((user){
                         ManagerServices.addABillRequest(user.uid, buildingID, int.parse(_billAmount.text), _billDescription.text, _billLabel.text, _selectedTenants,_billDueDate.month.toString()+"|"+
                             _billDueDate.day.toString()+"|"+_billDueDate.year.toString()).then((r){
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

                     }
                   }else{
                     setState(() {
                       error = "الرجاء إدخال الحقول المفقودة";
                     });
                   }
                 },
               ),

             ],


           ),



         ),




       );
      }

    }

    // this dialog is used to show the box with tenants and checkboxes
    // ignore: must_be_immutable
    class DialogContent extends StatefulWidget {
      var tenantsNamesMap;
      var tenantsNames;
      var selectedTenants;
      DialogContent({Key key, @required this.tenantsNamesMap,@required this.tenantsNames,@required this.selectedTenants}) : super(key: key);
      @override
      _DialogContentState createState() => new _DialogContentState(tenantsNamesMap: tenantsNamesMap,tenantsNames: tenantsNames,selectedTenants: selectedTenants);
    }

    class _DialogContentState extends State<DialogContent> {
      var tenantsNamesMap = {};
      var tenantsNames = [];
      var selectedTenants = [];
      _DialogContentState({Key key, @required this.tenantsNamesMap,@required this.tenantsNames,@required this.selectedTenants});

      @override
      void initState(){
        super.initState();
      }


      @override
      Widget build(BuildContext context) {
        return Container(
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement

          child: new ListView(
            children: <Widget>[
              Column(
                children: tenantsNames.map((name)=>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Text(name) ,
                        ),
                        Checkbox(
                            value: selectedTenants.contains(tenantsNamesMap[name]),
                            onChanged: (bool value){
                              setState(() {

                                if(selectedTenants.contains(tenantsNamesMap[name])){
                                  selectedTenants.remove(tenantsNamesMap[name]);
                                }else{
                                  selectedTenants.add(tenantsNamesMap[name]);
                                }

                              });
                            }
                        ),

                      ],
                    )
                ).toList(),
              )
            ],

          ),
        );
      }
    }