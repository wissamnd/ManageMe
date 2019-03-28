import 'Building.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
class User {
  String fullName;
  String uid;
  List<dynamic> buildings;
  String phoneNumber;
  String email;
  String photo;
  String about;
  bool traveling;

  User(this.fullName, this.uid, this.buildings, this.phoneNumber, this.email,
      this.photo, this.about, this.traveling);

  User.instance(){
    this.fullName = "";
    this.uid = "";
    this.buildings = [""];
    this.phoneNumber = "";
    this.email = "";
    this.photo = "";
    this.about ="";
    this.traveling = false;

  }
  List<String> _getBuildingNames(){
    List<String> l = [];
    for(int i = 0; i < buildings.length; i++){
      l.add(buildings[i].buildingName);
    }
    return l;
  }
  void updateAllInfoInDatabase() {
    DocumentReference ref = Firestore.instance.collection("users").document(
        this.uid);
    ref.setData({
      'fullName': this.fullName,
      'uid': this.uid,
      'buildings': _getBuildingNames(),
      'phonenumber': this.phoneNumber,
      'email': this.email,
      'photo': this.photo,
      'about': this.about,
      'traveling': this.traveling
    }, merge: true);
  }

  @override
  String toString() {
    return 'User{fullName: $fullName, uid: $uid, buildings: $buildings, phoneNumber: $phoneNumber, email: $email, photo: $photo, about: $about, traveling: $traveling}';
  }


}