import 'package:flutter/widgets.dart';

///
/// Booking Sadiums Classes Design
/// Author: Abdullah Khaled
/// june 21,2019
///

/* TODO: 1-add from json functions
         2-add transations methods in booking functions 
*/
class User {
  AssetImage profilePicture;
  List<String> notifications;
  String _userName, _password, _name;
  var _personalInfo = [];
  var _transactionInfo = [];
  User.fromJson(Map user);
  User(
      {notifications,
      userName,
      password,
      name,
      personalinfo,
      transctionsInfo}) {
    this.notifications = notifications;
    this._userName = userName;
    this._password = password;
    this._name = name;
    this._personalInfo = personalinfo;
    this._transactionInfo = transctionsInfo;
  }

  void addPersonalInfo(String personali) {
    this._personalInfo.add(personali);
  }

  void addTransactionInfo(dynamic trani) {
    this._personalInfo.add(trani);
  }

  get userName => this._userName;
  get password => this._password;
  get name => this._name;
  List<String> get personalInfo => this._personalInfo;
  get transactionInfo => this._transactionInfo;

  set userName(String username) => this._userName = username;
  set password(String password) => this._password = password;
  set name(String name) => this._name;
  set personalInfo(var personali) => this._personalInfo = personali;
  set transactionInfo(var ti) => this._transactionInfo = ti;
}

class Player extends User {
  List<Stadium> _favorites;
  List<Stadium> _bookedStadiums;

//constructor
  Player(
      {profilePicture,
      userName,
      password,
      name,
      personalinfo,
      transctionsInfo,
      List<Stadium> favoritesList,
      bookedStadiums,
      notifications}) {
    this.profilePicture = profilePicture;
    this.notifications = notifications;
    this._userName = userName;
    this._password = password;
    this._name = name;
    this._personalInfo = personalinfo;
    this._transactionInfo = transctionsInfo;
    this._favorites = favoritesList;
    print(favoritesList[0].name);
    this._bookedStadiums = bookedStadiums;
  }

  List<Stadium> get favorites => this._favorites;

  void addToFav(Stadium stadium) {
    // the last stadium will appear first
    this._favorites = [stadium, ..._favorites];
  }

  bool book(DateTime start, DateTime end, Stadium stadium) {
    bool result = stadium.occupy(start, end);
    print("result $result");
    return result;
  }
}

class Owner extends User {
  List<Stadium> stadiums = [];
  Owner({userName, password, name, personalinfo, transctionsInfo, staduims}) {
    this._userName = userName;
    this._password = password;
    this._name = name;
    this._personalInfo = personalinfo;
    this._transactionInfo = transctionsInfo;
    this.stadiums = staduims;
  }

  void addStaudim(Stadium s) => this.stadiums.add(s);

  void removeStadium(Stadium s) => this.stadiums.remove(s);

  getTimeTable(Stadium s) => s.timetable;
  setTimeTable(
    Stadium s,
  ) =>
      s.timetable;
}

class Stadium {
  String _extras;
  List<DTBlock> _timeTable = List<DTBlock>();
  String _phoneNumber;
  List<String> _pics;
  String name;
  String _location;
  String otherInfromations;
  List<String> posts = List<String>();

  List<dynamic> get pics => this._pics;

  get phone => this._phoneNumber;
  set phone(String phone) {
    try {
      this._phoneNumber = phone;
    } on FormatException {
      this._phoneNumber = null;
      print("enter a valid phone number");
    }
  }

  Stadium({name, location, pics, otherInformations, phone}) : super() {
    this._phoneNumber = phone;
    this.name = name;
    this._location = location;
    this._pics = pics;
    this.otherInfromations = otherInformations;
  }

  List<DTBlock> get timetable => this._timeTable;
  get extras => this._extras;
  get location => this._location;
  bool occupy(DateTime start, DateTime end) {
    bool result = true;
    // i don't care about these dt blocks whoes end time before my starting time
    List<DTBlock> search = []..addAll(this._timeTable);
    search.removeWhere((test) => test.end.isBefore(start));
    DTBlock b = DTBlock(start, end);
    search.forEach((block) {
      print("intersection: ${intersects(block, b)}");
      result &= !intersects(block, b);
    });
    if (result) _timeTable.add(b);
    return result;
  }
}

/*  bookign mechanism:
      user will enter the booking date:
          if it's occupied => error output message
          else=> book from start to end time(start+ #hours)
          transfer money from user's to owner's account    
 */

class DTBlock {
  DateTime start, end;
  bool confirmed = false;
  DTBlock(this.start, this.end);
  @override
  String toString() {
    return """من ${start.month}:${start.day} الساعة ${start.hour}:${start.minute}
 الى ${end.month}:${end.day} الساعة ${end.hour}:${end.minute}
 الحالة: ${confirmed?"مؤكد":"غير مؤكد"}
 -------------------------------------""";
  }
}

bool intersects(DTBlock block1, DTBlock block2) {
  if (((block1.start.isAfter(block2.start) ||
              (block1.start.compareTo(block2.start) == 0)) &&
          block1.start.isBefore(block2.end)) ||
      ((block2.start.isAfter(block1.start) ||
              block2.start.compareTo(block1.start) == 0) &&
          block2.start.isBefore(block1.end))) return true;
  return false;
}
