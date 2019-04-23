
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login/Logger.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount extends StatefulWidget{
    @override
  _UserAccountState createState() => _UserAccountState();
}
enum Options { uploadPhoto, signOUt}
class _UserAccountState extends State<UserAccount>{
  File _image;
  var uid = "";
  var fullName = "";
  var email = "";
  var aboutMe = "";
  var urlImage = "http://www.personalbrandingblog.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
  var phoneNumber = "";
  var traveling = false;
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController aboutMeController = new TextEditingController();


  // uploading photo to Firebase storage
  Future uploadPhoto(File avatarImageFile) async {

    String fileName = uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          setState(() {
            urlImage = downloadUrl;
          });
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({
            'photo': downloadUrl
          });
        });
      }
    });
  }
  // getting the image from the device
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget _fullNameDisplay(){
    if(fullName.length == 0){
      return new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else{
      return Text(fullName,style: TextStyle(color: Colors.white,fontSize: 30),);
    }
  }
  Widget _phoneNumberDisplay(){
    if(phoneNumber.length == 0){
      return new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else{
      return Text(phoneNumber,style: TextStyle(fontSize: 20,color: Colors.white),);
    }
  }
  Widget _emailDisplay(){
    if(email.length == 0){
      return new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else{
      return Text(email,style: TextStyle(fontSize: 20,color: Colors.white),);
    }
  }
  Widget _aboutMeDisplay(){
    if(aboutMe.length == 0){
      return new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else{
      return Text(aboutMe,style: TextStyle(fontSize: 20,color: Colors.white),);
    }
  }

  // getting user data using the MeAPI
  void getUserData(String uid) async {
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
    var valueMap = json.decode(result.body);
    setState(() {
      fullName = valueMap["fullName"];
      email = valueMap["email"];
      aboutMe = valueMap["about"];
      urlImage = valueMap["photo"];
      phoneNumber = valueMap["phonenumber"];
      traveling = valueMap["traveling"];
    });
  }
  // patching user data using from the database
  Future<String> apiPatchRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.patchUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user){
      getUserData(user.uid);
      setState(() {
        uid = user.uid;
      });
    });
    // call Firebase user to get current user


  }
   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         centerTitle: true,
         title: Text("إدارة الملف الشخصي",style: TextStyle(fontSize: 20,color: Colors.white),),
         backgroundColor: Color.fromRGBO(101, 127, 172, 0.5),
         actions: <Widget>[
           PopupMenuButton<Options>(
             onSelected: (Options result) {
               if(result == Options.signOUt){
                 FirebaseAuth.instance.signOut().then((action) {
                   Navigator.pushReplacement(context, new MaterialPageRoute(
                       builder: (context) =>
                       new LoginPage())
                   );
                 }).catchError((e) {
                   print(e);
                 });
               }else if(result == Options.uploadPhoto){
                 getImage().then((_){
                   uploadPhoto(_image);
                 });
               }
             },
             itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
               const PopupMenuItem<Options>(
                 value: Options.uploadPhoto,
                 child: Text('تغيير الصورة'),
               ),
               const PopupMenuItem<Options>(
                 value: Options.signOUt,
                 child: Text('الخروج'),
               ),
             ],
           )
         ],
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
                     child: _fullNameDisplay()
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
                                    apiPatchRequest('https://bmsdata-b4ded.firebaseapp.com/api/v1/editMyInfo?uid='+uid, {
                                      "fullName" : fullNameController.text
                                    });
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
                     _phoneNumberDisplay(),
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
                       child: _emailDisplay(),
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
                                     apiPatchRequest('https://bmsdata-b4ded.firebaseapp.com/api/v1/editMyInfo?uid='+uid, {
                                       "email" : emailController.text
                                     });
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
                       child: _aboutMeDisplay(),
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
                                       apiPatchRequest('https://bmsdata-b4ded.firebaseapp.com/api/v1/editMyInfo?uid='+uid, {
                                         "about" : aboutMeController.text
                                       });
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
                               apiPatchRequest('https://bmsdata-b4ded.firebaseapp.com/api/v1/editMyInfo?uid='+uid, {
                                 "traveling" : true
                               });
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
                               apiPatchRequest('https://bmsdata-b4ded.firebaseapp.com/api/v1/editMyInfo?uid='+uid, {
                                 "traveling" : false
                               });
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
             ],
           ),
         )
       )
     );


  }
}