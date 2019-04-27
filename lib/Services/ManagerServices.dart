import 'package:http/http.dart' show get;
import 'dart:convert';
import 'dart:io';


class ManagerServices{

  // get the info of the bill using it's ID
  static Future getBillInfo(String billID) async{
    var result = await get("https://bmsdata-b4ded.firebaseapp.com/api/v1/getBillInfo?billID="+billID);
    var billMap = json.decode(result.body);
    return billMap;
  }

    // add Bill to a building
    static Future<String> addABillRequest(String uid,String buildingID,int amount,String description
    String label,List users,String dueTime) async {

    Map jsonMap = {
      "amount": amount,
      "description": description,
      "label": label,
      "users": users,
      "usersWhoPaid":[],
      "dueTime": dueTime
    };
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/addBill/?uid="+uid+"&buildingID="+buildingID));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }


  // add a bill to a building while repeating for 3 consecutive months
  static Future<String> addABillRequestRepeat(String uid,String buildingID,int amount,String description
  String label,List users,String dueTime) async {

  Map jsonMap = {
    "amount": amount,
    "description": description,
    "label": label,
    "users": users,
    "usersWhoPaid":[],
    "dueTime": dueTime
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/addBillRepeat/?uid="+uid+"&buildingID="+buildingID));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
  }


  // add a tenant to a building using his phone number
  static Future<String> addATenant(String uid, String buildingID, String phoneNumber) async {
    Map jsonMap = {
      "phoneNumber" : phoneNumber
    };
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.patchUrl(Uri.parse("https://bmsdata-b4ded.firebaseapp.com/api/v1/AddATenant?uid="+uid+"&buildingID="+buildingID));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
}