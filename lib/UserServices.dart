import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'User.dart';
import 'Building.dart';
import 'Bill.dart';

class UserServices{

  static CollectionReference refToUsers = Firestore.instance.collection("users");
  static CollectionReference refToBuildings = Firestore.instance.collection("buildings");

  static Future retrieveData(String currentUid, String data) async {
    DocumentSnapshot result = await refToUsers.document(currentUid).get();
    return await result.data[data];
  }

  static Future<User> getCurrentUserInfo(String currentUid) async{
    DocumentSnapshot result = await refToUsers.document(currentUid).get();
    var fullName = await result.data["fullName"];
    var uid = await result.data["uid"];
    var buildings = await result.data["buildings"];
    var phoneNumber = await result.data["phonenumber"];
    var email = await result.data["email"];
    var photo = await result.data["photo"];
    var about = await result.data["about"];
    var traveling = await result.data["traveling"];
    User currentUser = new User(fullName, uid, buildings, phoneNumber, email, photo, about, traveling);
    return currentUser;
  }

  static void updateAbout(String currentUid, String text){
    DocumentReference result = refToUsers.document(currentUid);
    result.updateData({
      "about" : text
    });
  }

  static void createABuilding(String currentUid,Building B ){
    DocumentReference ref = Firestore.instance.collection("buildings").document(B.buildingName);
    ref.setData({
      "buildingName" : B.buildingName,
      "address": B.address,
      "numberofApartments": B.numberOfApartments,
      "manager" : B.managerUid,
      "tenantsUID": B.tenantsUID,
      "billsID": B.tenantsUID,
    }, merge: true);
  }


  static Future<bool> checkIfUserIsInDatabase(String tenantUid) async{

    DocumentSnapshot userInfo = await refToUsers.document(tenantUid).get();
    if(!userInfo.exists){
       print("false");
       return false;
    }
    else{
      print("true");
      return true;
    }

  }
  static Future<String> addTenants(String uid, String buildingName, String tenantUid) async{

    DocumentSnapshot result = await refToBuildings.document(buildingName).get();
    // getting the current manager of the building
    String manager = await result.data["manager"];

    var tenants = new List<String>.from(await result.data["tenantsUID"]);
    tenants.add(tenantUid);

    if(await checkIfUserIsInDatabase(tenantUid)){
      if(uid == manager){
        DocumentReference ref = refToBuildings.document(buildingName);
        ref.updateData({
          "tenantsUID" : tenants
        });
        return "Ok";
      }else{
        return "Access Denied";
      }
    }else{
      return "This phone number is not registered";

    }
  }

  static void addBills(String uid, Bill bill, Building bl) async {
    DocumentSnapshot result = await Firestore.instance.collection("buildings").document(bl.buildingName).get();
    String manager = await result.data["manager"];
    var bills = new List<String>.from(await result.data["billsID"]);
    bills.add(bill.bId);

    if(uid != manager ){
      print("Access Denied");
    }
    else{
      DocumentReference ref = Firestore.instance.collection("buildings").document(bl.buildingName);
      DocumentReference addRef = Firestore.instance.collection("bills").document(bill.bId);

      ref.updateData({
        "billsID" : bills
      });

      addRef.setData({
        "users" : bill.users,
        "usersWhoPaid": bill.usersWhoPaid,
        "amount": bill.amount,
        "dueDate": bill.dueDate,
        "label": bill.label,
        "repeat": bill.repeat,
        "description" : bill.description,
      });

    }
  }
  static Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}