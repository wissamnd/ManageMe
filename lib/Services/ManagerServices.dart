

import 'package:http/http.dart' show get;
import 'dart:convert';


class ManagerServices{
  static Future getBillInfo(String billID) async{
    var result = await get("https://bmsdata-b4ded.firebaseapp.com/api/v1/getBillInfo?billID="+billID);
    var billMap = json.decode(result.body);
    return billMap;
  }
}