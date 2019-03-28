import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login/Logger.dart';
import 'User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserServices.dart';
import 'Building.dart';
import 'Bill.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile> {

  static User currentUser = User.instance();
  bool checker;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val) {
        Building bl = new Building("Example", "Hamra Street", 11, val.uid, [val.uid], []);
//        UserServices.createABuilding(val.uid, B);
//        UserServices.AddTenats(val.uid, "Example", "1264325615hdstdfrw");
//        UserServices.updateAbout(val.uid, "Hello my name is wissam");
//        Bill b = new Bill("huehwewnhdbwduw", [val.uid], 1.0, new DateTime(2019), "E", true, 'null',[]);
//        UserServices.AddBills(val.uid, b, bl);
//       UserServices.checkIfUserIsInDatabase(val.uid);
        UserServices.getCurrentUserInfo(val.uid).then((user){
          setState(() {
            currentUser = user;
          });
        });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 127, 172, 1),
        body: new Center(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: new Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage("https://www.w3schools.com/howto/img_avatar.png"),
                  radius: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: new Text('Hello, '+ currentUser.fullName,style: TextStyle(color: Colors.white,fontSize: 20),),
                ),

                new Text('Your phone number is '+currentUser.phoneNumber),
                new Text('Your Current Building is '+currentUser.buildings.toString()),
//                new Text(currentUser.toString()),

                SizedBox(
                  height: 15.0,
                ),
                new OutlineButton(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 3.0),
                  child: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((action) {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          new LoginPage())
                      );
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ],
            ),
          ),
        )
    );

  }
}
