


class DateServices{

  // month must be between 1 and 12 inclusive
  static getMonthName(int month){
    var monthLst = ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران', 'تموز',
    'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'];
    return monthLst[month-1];
  }




}