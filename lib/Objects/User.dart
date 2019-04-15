import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String fullName;
  String uid;
  List<dynamic> buildings;
  String phoneNumber;
  String email;
  String photo;
  String about;
  bool traveling;
  List<String> messages;

  User(this.fullName, this.uid, this.buildings, this.phoneNumber, this.email,
      this.photo, this.about, this.traveling,this.messages);

  void updateAllInfoInDatabase() {
    DocumentReference ref = Firestore.instance.collection("users").document(
        this.uid);
    ref.setData({
      'fullName': this.fullName,
      'uid': this.uid,
      'buildings': [],
      'phonenumber': this.phoneNumber,
      'email': this.email,
      'photo': this.photo,
      'about': this.about,
      'traveling': this.traveling,
      'messages': messages
    }, merge: true);
  }
  @override
  String toString() {
    return 'User{fullName: $fullName, uid: $uid, buildings: $buildings, phoneNumber: $phoneNumber, email: $email, photo: $photo, about: $about, traveling: $traveling}';
  }
}