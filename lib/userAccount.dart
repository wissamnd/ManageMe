
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login/Logger.dart';

class UserAccount extends StatefulWidget{
    @override
  _UserAccountState createState() => _UserAccountState();
}


class _UserAccountState extends State<UserAccount>{
  File _image;
  var fullName = "Wissam Noureddine";
  var email = "wissam@mail.com";
  var aboutMe = "Hello my name is wissam l am  testing this app right now ";
  var urlImage = "https://www.w3schools.com/howto/img_avatar.png";
  var traveling = false;
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController aboutMeController = new TextEditingController();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         title: Text("إدارة الملف الشخصي",style: TextStyle(fontSize: 20,color: Colors.white),),
         backgroundColor: Color.fromRGBO(101, 127, 172, 0.5),
       ),
       backgroundColor: Color.fromRGBO(101, 127, 172, 1),
       body: new Container(

         child:  new Center(
           child:ListView(
             padding: EdgeInsets.only(top:50),

             children: <Widget>[

               Center(
                 child:CircleAvatar(
                   backgroundImage: NetworkImage(urlImage),
                   radius: 90,
                 ),
               ),

               Center(
                 child:Container(
                     padding: EdgeInsets.only(top: 20),
                     child: Text(fullName,style: TextStyle(color: Colors.white,fontSize: 30),)
                 ),
               ),



               Container(

                 child: new Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     MaterialButton(
                       padding: EdgeInsets.only(left:1),
                       child:Icon(Icons.edit,color: Colors.white,),
                       onPressed: (){
                          showDialog(context: context,
                          builder: (_) => new AlertDialog(
                            title: Text("تغيير الاسم الكامل",textAlign: TextAlign.end,),
                            content: new TextField(
                              controller: fullNameController,
                              maxLength: 20,
                              textAlign: TextAlign.end,
                           ),
                            actions: <Widget>[
                              new MaterialButton(child: Text("تقديم",),onPressed: (){
                                if(fullNameController.text.length > 0){
                                  Navigator.of(context).pop();
                                  setState(() {
                                    fullName = fullNameController.text;
                                    // Call a function to change name in database
                                  });
                                }
                           })
                           ],

                          ) );
                       },
                     ),
                   ],
                 ),
               ),
               Container(
                 padding: EdgeInsets.all(10),
                 child:new Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text("+961 76820378",style: TextStyle(fontSize: 15,color: Colors.white),),
                     Text("رقم الهاتف",style: TextStyle(fontSize: 15,color: Colors.white) ,),

                   ],
                 ) ,
               ),
               Container(
                 padding: EdgeInsets.all(10),
                 child: new Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Flexible(
                       child: Text(email,style: TextStyle(fontSize: 15,color: Colors.white),),
                     ),

                     MaterialButton(
                       padding: EdgeInsets.only(left:1),
                       child: Icon(Icons.edit,color: Colors.white,),
                       onPressed: (){
                         showDialog(context: context,
                             builder: (_) => new AlertDialog(
                               title: Text("تغيير البريد الإلكتروني",textAlign: TextAlign.end,),
                               content: new TextField(
                                 maxLength: 18,
                                 controller: emailController,
                               ),
                               actions: <Widget>[
                                 new MaterialButton(child: Text("تقديم",),onPressed: (){
                                   if(emailController.text.length > 0){
                                     Navigator.of(context).pop();
                                     setState(() {
                                       email = emailController.text;
                                       // Call a function to change name in database
                                     });
                                   }
                                 })
                               ],

                             ) );
                       },
                     ),

                     Text("البريد الإلكتروني",style: TextStyle(fontSize: 15,color: Colors.white),),



                   ],
                 ),
               ),
               Container(
                 padding: EdgeInsets.all(10),
                 child: new Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Flexible(
                       child: Text(aboutMe,style: TextStyle(fontSize: 15,color: Colors.white),maxLines: null,),
                     ),
                     MaterialButton(
                       padding: EdgeInsets.only(left:1),
                       child: Icon(Icons.edit,color: Colors.white,),
                       onPressed: (){
                         showDialog(context: context,
                             builder: (_) => new AlertDialog(
                               title: Text("تغيير المعلومات اضافية",textAlign: TextAlign.end,),
                               content: new TextField(
                                 textAlign: TextAlign.end,
                                 maxLength: 120,
                                 maxLines: null,
                                 controller: aboutMeController,

                               ),
                               actions: <Widget>[
                                 new MaterialButton(child: Text("تقديم",),onPressed: (){
                                   if(aboutMeController.text.length > 0){
                                     Navigator.of(context).pop();
                                     setState(() {
                                       aboutMe = aboutMeController.text;
                                       // Call a function to change name in database
                                     });
                                   }
                                 })
                               ],

                             ) );
                       },
                     ),
                     Text("معلومات اضافية",style: TextStyle(fontSize: 15,color: Colors.white),),




                   ],
                 ),
               ),


               new Container(
                 padding: EdgeInsets.all(10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[

                     Row(
                       children: <Widget>[

                         new RaisedButton(
                           child: new Text('نعم'),
                           textColor: Colors.blueAccent,
                           shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(5.0),
                           ),
                           color: traveling ? Colors.white : Colors.black87,
                           onPressed: (){
                             if(!traveling){
                               setState(() => traveling = !traveling);
                             }

                           },
                         ),
                         new RaisedButton(
                           child: new Text('لا'),
                           textColor: Colors.blueAccent,
                           shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(5.0),
                           ),
                           color: traveling ? Colors.black87 : Colors.white,
                           onPressed: (){
                             if(traveling){
                               setState(() => traveling = !traveling);
                             }

                           },
                         ),

                       ],
                     ),
                     Text("مسافر",style: TextStyle(fontSize: 15,color: Colors.white),),


                   ],
                 ) ,
               ),
               Container(
                 child:Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     SizedBox(
                       width: 200,
                       child:new RaisedButton(
                         child: new Text('تغيير الصورة'),
                         textColor: Colors.blueAccent,
                         shape: new RoundedRectangleBorder(
                           borderRadius: new BorderRadius.circular(10.0),
                         ),
                         color: Colors.white,
                         onPressed: (){
                           getImage().then((_){
                             print(_image);
                           });
                         },
                       ),
                     )

                   ],
                 )
               ),
               Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     SizedBox(
                       width: 200,
                       child: MaterialButton(
                           textColor: Colors.white,
                           color: Colors.red,
                           child: new Text("الخروج"),
                           onPressed: (){
                             FirebaseAuth.instance.signOut().then((action) {
                               Navigator.pushReplacement(context, new MaterialPageRoute(
                                   builder: (context) =>
                                   new LoginPage())
                               );
                             }).catchError((e) {
                               print(e);
                             });
                           }
                       ),
                     ),
                   ],
                 ),
               ),

             ],
           ),
         )
       )
     );


  }
}