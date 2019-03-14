import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Center(
              child: Text('Briefing for '+getCurrentMonth()),
            )
        ),
        backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        body:Container(
            child:Column(
              children: <Widget>[
//                Dash(),
//           Container(
//             padding: EdgeInsets.all(8.0),
//             width: double.infinity,
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text("The ammount due in you bill is", style: TextStyle(color: Colors.white),),
//                   Text("50 \$", style: TextStyle(color: Colors.white),),
//                  RaisedButton(
//                 onPressed: () {
//                   final snackBar = SnackBar(
//                     content: Text('Last day for payment is Feb,9,2019'),
//                     action: SnackBarAction(
//                       label: "",
//                       onPressed: () {
//                         // Some code to undo the change!
//                       },
//                     ),
//                   );
//
//                   // Find the Scaffold in the Widget tree and use it to show a SnackBar!
//                   Scaffold.of(context).showSnackBar(snackBar);
//                 },
//                 child: Text('Show SnackBar'),
//               )
//
//                 ],
//               )
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.blue,
//               border: Border.all(
//                 color: Colors.blue,
//                 width: 8.0,
//               ),
//             ),
//           ),

              ],
            )
        )
    );
  }
}

//class Dash extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) {
//
//      return Container(
//        padding: EdgeInsets.all(8.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          children: <Widget>[
//            Text("January",style: TextStyle(color: Colors.white,fontSize: 20.0 ),),
//            Text("March",style: TextStyle(color: Colors.white,fontSize: 20.0 )),
//            MaterialButton(
//              child: Text("April",style: TextStyle(color: Colors.white,fontSize: 20.0 )),
//              onPressed: () => displaySnackBar(context,"April is pressed"),
//            )
//          ],
//        ),
//      );
//  }
//}

displaySnackBar(BuildContext context, String text){
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: "",
      onPressed: () {
        // Some code to undo the change!
      },
    ),
  );

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  Scaffold.of(context).showSnackBar(snackBar);
}

getCurrentMonth(){
  var monthLst = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
  'August', 'September', 'October', 'November', 'December'];
  var now = DateTime.now();
  return monthLst[now.month - 1];
}