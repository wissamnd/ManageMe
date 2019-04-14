import 'package:ManageMe/Objects/User.dart';
import 'package:ManageMe/Objects/Bill.dart';


class Building{
  String buildingName;
  String address;
  int numberOfApartments;
  String managerUid;
  List<String> tenantsUID;
  List<String> billsID;

  Building(this.buildingName, this.address, this.numberOfApartments,
      this.managerUid, this.tenantsUID, this.billsID);

  int getRemainingApartments(){
    return numberOfApartments - tenantsUID.length;
  }




}