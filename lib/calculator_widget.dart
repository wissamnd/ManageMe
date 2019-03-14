import 'package:flutter/material.dart';


class Calculator extends StatefulWidget{

  @override
  State createState() {
      return new CalculatorState();
  }
}

class CalculatorState extends State<Calculator>{
  final TextEditingController t1 = new TextEditingController(text: "0");
  final TextEditingController t2 = new TextEditingController(text: "0");
  var numberOne =0, numberTwo=0, sum=0.0;

  void doAddition(){
    setState(() {
      numberOne = int.parse(t1.text);
      numberTwo = int.parse(t2.text);
      sum = (numberOne + numberTwo).toDouble();
    });
  }

  void doSubtraction(){
    setState(() {
      numberOne = int.parse(t1.text);
      numberTwo = int.parse(t2.text);
      sum = (numberOne - numberTwo).toDouble();
    });
  }

  void doDivision(){
    setState(() {
      numberOne = int.parse(t1.text);
      numberTwo = int.parse(t2.text);
      sum = numberOne / numberTwo;
    });
  }

  void doMultiplication(){
    setState(() {
      numberOne = int.parse(t1.text);
      numberTwo = int.parse(t1.text);
      sum = (numberOne * numberTwo).toDouble();
    });
  }

  void doClear(){
    setState(() {
      t1.text = "0";
      t2.text = "0";
      numberTwo = 0;
      numberOne = 0;
      sum = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Output: $sum",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: t1,
            decoration: new InputDecoration(
              hintText: "Enter Number 1"
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: t2,
            decoration: new InputDecoration(
                hintText: "Enter Number 1",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new MaterialButton(
                  child: new Text("+"),
                  textColor: Colors.black,
                  color: Colors.cyanAccent,
                  onPressed: () =>doAddition(),
                  ),
              new MaterialButton(
                  child: new Text("-"),
                  textColor: Colors.black,
                  color: Colors.cyanAccent,
                  onPressed: doSubtraction
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new MaterialButton(
                  child: new Text("*"),
                  textColor: Colors.black,
                  color: Colors.cyanAccent,
                  onPressed: doMultiplication
              ),
              new MaterialButton(
                  child: new Text("/"),
                  textColor: Colors.black,
                  color: Colors.cyanAccent,
                  onPressed: doDivision
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new MaterialButton(
                  child: new Text("Clear"),
                  textColor: Colors.black,
                  color: Colors.cyanAccent,
                  onPressed: doClear
              ),
            ],
          )
        ],
      )
    );
  }
  
}