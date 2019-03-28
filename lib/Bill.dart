import 'User.dart';
class Bill{
  String bId;
  List<String> users;
  List<String> usersWhoPaid;
  double amount;
  DateTime dueDate;
  String label;
  bool repeat;
  String description;
  Bill(this.bId,this.users, this.amount, this.dueDate, this.label, this.repeat,
      this.description,this.usersWhoPaid);
}