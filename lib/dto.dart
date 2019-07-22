import 'package:flutter/widgets.dart';
import 'daf.dart';

///
/// Booking Sadiums Classes Design
/// Author: Abdullah Khaled
/// june 21,2019
///

/* 
         2-add transations methods in booking functions 
*/
class User {
  int userId;
  AssetImage _profilePicture;
  List<String> notifications = List<String>();
  String _userName, _password, _name;
  var _personalInfo = [];
  var _transactionInfo = [];
  User.fromJson(Map user);
  User({userName, password, name, personalinfo, transctionsInfo}) {
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
  set name(String name) => this._name = name;
  set personalInfo(List<String> personali) => this._personalInfo = personali;
  set transactionInfo(var ti) => this._transactionInfo = ti;
  get profilePicture => this._profilePicture;

  setProfilePicture(int index) {
    this._profilePicture = index != null
        ? AssetImage("images/${index.toString()}.png")
        : AssetImage("images/user.png");
    changeAvatar(userId: this.userId, avatarIndex: index);
  }
}

class Player extends User {
  int id;
  List<Stadium> _favorites = List<Stadium>();

//constructor
  Player(
      {profilePicture,
      userName,
      password,
      name,
      personalinfo,
      transctionsInfo,
      List<Stadium> favoritesList,
      notifications}) {
    this.notifications = notifications;
    this._userName = userName;
    this._password = password;
    this._name = name;
    this._personalInfo = personalinfo;
    this._transactionInfo = transctionsInfo;
    this._favorites = (favoritesList != null) ? favoritesList : this._favorites;
  }

  List<Stadium> get favorites => this._favorites;
  set favorites(List<Stadium> stadiums) => this._favorites = stadiums;
  void addToFav(Stadium stadium) {
    // the last stadium will appear first
    this._favorites = [stadium, ..._favorites];
  }

  bool book(DateTime start, DateTime end, Stadium stadium) {
    bool result = stadium.occupy(start, end, this.id);
    print("result $result");
    return result;
  }
}

class Owner extends User {
  int id;
  List<Stadium> stadiums = List<Stadium>();
  Owner({userName, password, name, personalinfo, transctionsInfo, staduims}) {
    this._userName = userName;
    this._password = password;
    this._name = name;
    this._personalInfo = personalinfo;
    this._transactionInfo = transctionsInfo;
    this.stadiums = (staduims != null) ? staduims : this.stadiums;
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
  int id;
  List<DTBlock> _timeTable = List<DTBlock>();
  String _phoneNumber;
  List<String> _pics;
  String name;
  String _location;
  List<String> posts = List<String>();
  set timeTable(List<DTBlock> input) => this._timeTable = input;
  List<dynamic> get pics => this._pics;
  get timeTable => this._timeTable;
  @override
  String toString() {
    return "stadium's name: ${this.name}";
  }

  set pics(List<String> pics) => this._pics = pics;
  get phone => this._phoneNumber;
  set phone(String phone) {
    try {
      this._phoneNumber = phone;
    } on FormatException {
      this._phoneNumber = null;
      print("enter a valid phone number");
    }
  }

  set location(String location) => this._location = location;
  Stadium({name, location, pics, otherInformations, phone}) : super() {
    this._phoneNumber = phone;
    this.name = name;
    this._location = location;
    this._pics = pics;
  }
  prepareTimeTable() async {
    _timeTable = await getAllDateTimeBlockByStadiumId(stadiumId: id);
  }

  List<DTBlock> get timetable => this._timeTable;
  get location => this._location;

  bool occupy(DateTime start, DateTime end, int playerId) {
    prepareTimeTable();
    bool result = true;
    // i don't care about these dt blocks whoes end time before my starting time
    List<DTBlock> search = []..addAll(this._timeTable);
    search.removeWhere((test) => test.end.isBefore(start));
    DTBlock b = DTBlock(start: start, end: end);
    search.forEach((block) {
      print("intersection: ${intersects(block, b)}");
      result &= !intersects(block, b);
    });
    if (result) {
      _timeTable.add(b);
      addDTBlockFormStadium(dtBlock: b, playerId: playerId, stadiumId: this.id);
    }
    return result;
  }

  writePost(String post) async {
    posts.add(post);
    await addNewPost(post: post, stadiumId: this.id);
  }
}

/*  bookign mechanism:
      user will enter the booking date:
          if it's occupied => error output message
          else=> book from start to end time(start+ #hours)
          transfer money from user's to owner's account    
 */

class DTBlock {
  int id;
  DateTime start, end;
  bool confirmed = false;
  DTBlock({this.start, this.end});
  @override
  String toString() {
    return """من ${start.month}:${start.day} الساعة ${start.hour}:${start.minute}
 الى ${end.month}:${end.day} الساعة ${end.hour}:${end.minute}
 الحالة: ${confirmed ? "مؤكد" : "غير مؤكد"}
 -------------------------------------""";
  }
}

bool intersects(DTBlock block1, DTBlock block2) {
  if(block1.start==null || block1.end==null || block2.start==null || block2.end==null) return true;
  if((block1.start.isBefore(block2.end)||block1.start.compareTo(block2.end)==0)
  &&((block1.end.isAfter(block2.start))||block1.end.compareTo(block2.start)==0)) return true;

  return false;
}
