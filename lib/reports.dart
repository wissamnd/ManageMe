import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:flutter/material.dart';
class Reports extends StatefulWidget{

  @override
  _Reports createState() {
    return _Reports();

  }
}


class _Reports extends State<Reports>{
  DateTime _selectedDate1 = new DateTime.now();
  DateTime _selectedDate2 = new DateTime.now();
  List<String> selectFormat = ["PDF", "Excel"];
  String _selectedFileFormat = "PDF";

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019),
        lastDate: new DateTime(2030)

    );
    return picked;
  }
  String getMonth(int m ){
    var monthLst = ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران', 'تموز',
    'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'];
    return monthLst[m  - 1];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color.fromRGBO(101, 127, 172, 1),
            title: Center(
                child: Text('إصدار التقارير', textAlign: TextAlign.right,)
            )
        ),
        backgroundColor:Color.fromRGBO(101, 127, 172, 1)
        ,
        body: Container(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text("تنسيق الملف", textAlign: TextAlign.right,style: TextStyle(fontSize: 20)),
              new DropdownButton<String>(
                hint: Text(_selectedFileFormat),
                items: <String>['PDF', 'Excel'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value,style: TextStyle(fontSize: 20)),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    _selectedFileFormat = value;
                  });
                },
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),),
              Text("مقرر من", textAlign: TextAlign.right,style: TextStyle(fontSize: 20)),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                        child: Icon(Icons.calendar_today,color: Colors.white,),
                        onPressed: (){
                          _selectDate().then((date){
                            setState(() {
                              _selectedDate1 = date;
                            });
                          });
                        }),
                    Container(
                      padding: EdgeInsets.all(10),

                      decoration: new BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(getMonth(_selectedDate1.month) + " " + _selectedDate1.day.toString() + " "+ _selectedDate1.year.toString(),style: TextStyle(fontSize: 20),),
                    )

                  ],
                ),
              ),

              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),),
              Text("مقرر إلى", textAlign: TextAlign.right,style: TextStyle(fontSize: 20)),


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                        child: Icon(Icons.calendar_today,color: Colors.white,),
                        onPressed: (){
                          _selectDate().then((date){
                            setState(() {
                              _selectedDate2 = date;
                            });
                          });
                        }),
                    Container(
                      padding: EdgeInsets.all(10),

                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(getMonth(_selectedDate2.month) + " " + _selectedDate2.day.toString() + " "+ _selectedDate2.year.toString(),style: TextStyle(fontSize: 20),),
                    )

                  ],
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.white,
                    child: Container(padding: EdgeInsets.all(5),child: Text("إنشاء")),
                    onPressed: (){
                    },
                  )

                ],
              )




            ],
          )
          
        )
    );}



}