
import 'package:http/http.dart' show get;
import 'dart:convert';


// these services are called using an api
class UserServices{

   // gets the amount of bills in each building specified (If the building currency is USD it converts to LBP
   static Future _getAmountOfBills(String uid,String buildingID,int month, int year) async {
    var amount = 0;
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getMyMonthlyBuildingBills?uid='+uid+'&buildingID='+buildingID+'&month='+month.toString()+'&year='+year.toString());
    var listOfBills = json.decode(result.body);
    for(var i = 0 ; i < listOfBills.length;i++){
      if((listOfBills[i]["usersWhoPaid"].indexOf(uid) < 0)){
        if(listOfBills[i]["Currency"]== 'USD'){
          amount = amount + (listOfBills[i]["amount"]*1500);
        }else{
          amount = amount + listOfBills[i]["amount"];
        }
      }
    }
    return amount;
  }
  // function that gets the total amount of bill that user have in a building
  static Future getUserTotalDueBillsInAllBuildingsLBP(String uid,int month,int year) async {
    var amount = 0;
    var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
    var valueMap = json.decode(result.body);
    var buildingIDs = valueMap["buildings"].cast<String>();
    for(var i = 0; i < buildingIDs.length;i++){
      await _getAmountOfBills(uid, buildingIDs[i], month, year).then((number){
        amount += number;
      });
    }
    return amount;
  }

  // get user private notifications
   static Future getUserNotifications(String uid) async {
     var result = await get('https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid='+uid);
     var valueMap = json.decode(result.body);
     return valueMap["messages"].cast<String>();
   }

   // given a list of user IDs give there names
   static Future<List<String>>getUserName(List<dynamic> uids) async {
     List<String> names = [];
     for (int i = 0; i < uids.length; i++) {
       var result = await get(
           'https://bmsdata-b4ded.firebaseapp.com/api/v1/getUserInfo?uid=' +
               uids[i]);
       var valueMap = await json.decode(result.body);
       names.add(await valueMap["fullName"]);
     }
     return names;
   }


}