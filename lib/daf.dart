///Data access functions
///Author: Abdullah khaled

import 'package:extratime/constants.dart';
import 'package:extratime/dto.dart';
import 'package:mysql1/mysql1.dart';

//////////////  getters functions  ///////////////
///         Author: `Abdullah khaled`          ///
///  used to get out objects from database     ///
//////////////////////////////////////////////////

///Get user by username and password or id:
///    @args : [(username & password) | id]
///   `EXPECTED_OUTPUT` : a complete [Player|Owner] object

Future<Player> getPlayer({username, password, id}) async {
  final connection = await getConnection();
  int usrId;
  Results result = await connection.query(
      (username != null && password != null)
          ? "select ID,NAME,PROFILE_PICTURE_INDEX,USER_TYPE from USER where user_name = ? and password = ?"
          : "select * from USER where id=?",
      (username != null && password != null) ? [username, password] : [id]);
  var res;
  try {
    res = result.elementAt(0);
  } on IndexError {
    return null;
  }
  if (res[3] == 0) {
    Player outputUser = Player();
    for (var v in result) {
      usrId = v[0];
      outputUser.userId = v[0];
      v.forEach((value) => print(value));
      outputUser.userName = username;
      outputUser.password = password;
      outputUser.name = v[1].toString();
      outputUser.setProfilePicture(v[2]);
      Player temp = await _getPlayerById(id: v[0]);

      outputUser.favorites = temp.favorites;
      print("print notifications: ${temp.notifications}");
      outputUser.notifications = temp.notifications;
    }
    print(result.insertId);
    result = await connection
        .query("Select INFO FROM PERSONAL_INFO where USER_ID=?", [usrId]);

    try {
      if (result.elementAt(0)[0] != null) {
        outputUser.personalInfo = List<String>()..add(result.elementAt(0)[0]);
        print(result.elementAt(0)[0]);
      }
    } on IndexError {
      return null;
    }
    result = await connection
        .query("Select ID FROM PLAYER where USER_ID=?", [usrId]);
    try {
      outputUser.id = result.elementAt(0)[0];
    } on IndexError {
      return null;
    }
    connection.close();
    return outputUser;
  } else {
        connection.close();
    return null;
  }
}

Future<Owner> getOwner({username, password, id}) async {
  final connection = await getConnection();
  var userID;

  Results result = await connection.query(
      (username != null && password != null)
          ? "select * from USER where user_name = ? and password = ?"
          : "select * from USER where id=?",
      (username != null && password != null) ? [username, password] : [id]);
  print("usertype: ${result.length}");
  if(result.length==0) return null;
  if (result.elementAt(0)[5] == 1) {
    Owner outputUser = Owner();
    for (var v in result) {
      userID = v[0];
      outputUser.userName = v[1];
      outputUser.password = v[2];
      outputUser.name = v[3];
      outputUser.setProfilePicture(v[4]);
      Owner temp = await _getOwnerById(id: v[0]);
      outputUser.stadiums = temp.stadiums;
    }
    result = await connection
        .query("Select ID FROM OWNER WHERE USER_ID = ?", [userID]);
    outputUser.id = result.elementAt(0)[0];
        connection.close();

    return outputUser;
  } else {
        connection.close();

    return null;
  }
}

///Get stadium by id
/// @args :[id]
/// `EXPECTED_OUTPUT` : a new complete [Stadium] object

Future<Stadium> getStadiumById({id}) async {
  final connection = await getConnection();
  Results results =
      await connection.query("select * from STADIUM where ID = ?", [id]);

//TODO: checkpoint
  Stadium result = Stadium();
  for (var item in results) {
    result.id = item[0];
    result.name = item[1];
    result.location = item[2];
    result.posts = await getAllPostsForStadiumById(id: item[0]);
    result.pics = await getAllPicForStadiumById(id: item[0]);
    result.phone = item[3];
    result.timeTable = await getAllDateTimeBlockByStadiumId(stadiumId: item[0]);
    result.pricePerHour = item[4];
    result.stadiumType = item[5];    

  }
    connection.close();

  result.timeTable = await getAllDateTimeBlockByStadiumId(stadiumId: result.id);
  print("timeTable of stadium  ${result.timeTable}");
  return result;
}

Future<List<String>> getAllPicForStadiumById({id}) async {
  List<String> result = List<String>();
  final connection = await getConnection();
  Results results = await connection
      .query("select PIC from STADIUM_PICS where STADIUM_ID =?", [id]);

  for (var v in results) {
    result.add(v[0]);
  }
      connection.close();

  return result;
}

Future<List<String>> getAllPostsForStadiumById({id}) async {
  List<String> result = List<String>();
  final connection = await getConnection();
  Results results =
      await connection.query("select * from POSTS where  STADIUM_ID =?", [id]);

  for (var v in results) {
    result.add(v[1]);
  }
      connection.close();

  return result;
}

///Get a list of all stadiums:
/// `EXPECTED_OUTPUT` : a List of all stadiums in out database
Future<List<Stadium>> getListOfStadiums() async {
  List<Stadium> result = List<Stadium>();
  final connection = await getConnection();
  Results results = await connection.query("select * from STADIUM");

  for (var v in results) {
    Stadium stadium = Stadium();
    stadium.id = v[0];
    stadium.name = v[1];
    stadium.location = v[2];
    stadium.phone = v[3];
    stadium.posts = await getAllPostsForStadiumById(id: v[0]);
    stadium.pics = await getAllPicForStadiumById(id: v[0]);
    stadium.timeTable = await getAllDateTimeBlockByStadiumId(stadiumId: v[0]);
    stadium.pricePerHour = v[4];
    stadium.stadiumType = v[5];
    result.add(stadium);
  }
      connection.close();

  return result;
}

/// Get player by id:
///   [USE IT WITH CAUTION]
///   THIS FUNCTION WAS INTENDED TO RETURN AN INCOMPLETE `PLAYER` OBJECT
///   in othe words (Player without user properties)
///   AND SHOULDN'T BE USED IN OTHER CASES
Future<Player> _getPlayerById({id}) async {
  Player result = Player();
  final connection = await getConnection();
  Results results = await connection
      .query("Select id From player where USER_ID = ? ".toUpperCase(), [id]);
  for (var v in results) {
    result.id = v[0];
    print('user id:- ${result.id}');
  }
  results = await connection.query(
      "Select NOTIFICATION from NOTIFICATIONS where PLAYER_ID = ?",
      [result.id]);
  result.notifications = [];
  for (var v in results) {
    result.notifications.insert(0, v[0]);
  }
  result.favorites = await getFavStadiumsByPlayerId(id: result.id);
      connection.close();

  return result;
}

Future<List<Stadium>> getFavStadiumsByPlayerId({int id}) async {
  final connection = await getConnection();
  List<Stadium> result = List<Stadium>();
  Results results = await connection
      .query("Select STADIUM_ID from FAV_LIST where PLAYER_ID = ?", [id]);
  for (var item in results) {
    print("OoOooooooooooo item:  ${item[0]}");
    result.add(await getStadiumById(id: item[0]));
  }
      connection.close();

  return result;
}

/// Get owner by id:
///   [USE IT WITH CAUTION]
///   THIS FUNCTION WAS INTENDED TO RETURN AN INCOMPLETE `OWNER` OBJECT
///   in other words (Owner without user properties)
///   AND SHOULDN'T BE USED IN OTHER CASES
Future<Owner> _getOwnerById({id}) async {
  Owner result = Owner();
  final connection = await getConnection();
  Results results =
      await connection.query("select ID from OWNER where USER_ID =?", [id]);
  for (var item in results) {
    result.id = item[0];
  }
  results = await connection.query(
      "select STADIUM_ID from OWNER_STADIUM where OWNER_ID =?", [result.id]);
  for (var item in results) {
    print(result.stadiums);
    result.stadiums.add(await getStadiumById(id: item[0]));
  }
  result.stadiums.forEach((stadium) async {
    print("hi");
    stadium.timeTable =
        await getAllDateTimeBlockByStadiumId(stadiumId: stadium.id);
  });
    connection.close();

  return result;
}

Future<DTBlock> getDateTimeBlockById({id}) async {
  DTBlock result = DTBlock();
  final connection = await getConnection();
  Results results =
      await connection.query("select * from BLOCK_STADIUM where ID =?", [id]);
  for (var item in results) {
    result.start = item[2];
    result.end = item[3];
    result.confirmed = item[4];
  }
      connection.close();

  return result;
}

Future<List<DTBlock>> getAllDateTimeBlockByStadiumId({stadiumId}) async {
  List<DTBlock> result = List<DTBlock>();
  final connection = await getConnection();
  Results results = await connection.query(
      "select * from BLOCK_STADIUM where STADIUM_ID =?", [
    stadiumId
  ]); // Results results = await connection.query("select * from BLOCK_STADIUM where STADIUM_ID =?", [stadiumId]);
  for (var item in results) {
    DTBlock temp = DTBlock();
    temp.id = item[0];

    temp.start = item[3];
    temp.end = item[4];
    temp.confirmed = item[5] == 0 ? false : true;
    result.add(temp);
  }
      connection.close();

  return result;
}


//////////////////////////////////////////////////
///              adders functions              ///
///         Author: `Abdullah khaled`          ///
///  used to get out objects from database     ///
//////////////////////////////////////////////////

Future<bool> addNewPlayer({username, password, name, personalInfo}) async {
  final connection = await getConnection();
  //MySqlException (Error 1062 (23000): Duplicate entry 'user1' for key 'USERNAME_UNIQUE')
  var query;
  try {
    query = await connection.query(
        'insert into USER (USER_NAME , PASSWORD, NAME, USER_TYPE,PROFILE_PICTURE_INDEX) values (?, ?, ? ,?,?)',
        [username, password, name, 0, 0]);
  } on MySqlException {
        connection.close();

    return false;
  }

  int userId = query.insertId;
  query = await connection
      .query('insert into PLAYER (USER_ID) values (?)'.toUpperCase(), [userId]);

  query = await connection.query(
      'insert into PERSONAL_INFO (USER_ID,INFO) values (?,?)'.toUpperCase(),
      [userId, personalInfo]);
  print(query);
      connection.close();

  return true;
}

Future<bool> addNewOwner({username, password, name, personalInfo}) async {
  final connection = await getConnection();
  //MySqlException (Error 1062 (23000): Duplicate entry 'user1' for key 'USERNAME_UNIQUE')
  var query;
  try {
    query = await connection.query(
        'insert into USER (USER_NAME , PASSWORD, NAME, USER_TYPE,PROFILE_PICTURE_INDEX) values (?, ?, ? ,?,?)',
        [username, password, name, 1, 0]);
  } on MySqlException {
        connection.close();

    return false;
  }

  int userId = query.insertId;
  query = await connection
      .query('insert into OWNER (USER_ID) values (?)'.toUpperCase(), [userId]);
          connection.close();

  return true;
}

Future<bool> addNewStadium(
    {Owner owner, name, location, phone, List<String> pics,int pricePerHour,StadiumType stadiumType}) async {
  var listOfPics = pics??["http://www.polyplastic-piscine-34.com/images/no-images/no-image.jpg "];
  int ownerId = owner.id;
  var connection = await getConnection();
  var query;
  try {
    query = await connection.query(
        'insert into STADIUM (NAME,LOCATION,PHONE,PRICE_PER_HOUR,STADIUMTYPE) values (?,?,?,?,?)',
        [name, location, phone,pricePerHour,(stadiumType==StadiumType.FIVE_PLAYERS_BASED)?"0":"1"]);
  } on MySqlException {
        connection.close();
    return false;
  }
  
  int stadId = query.insertId;

  query = await connection.query(
      'insert into OWNER_STADIUM (OWNER_ID, STADIUM_ID) values (?,?)',
      [ownerId, stadId]);
 //socket exception (closed socket)
  listOfPics.forEach((picture) async{
    query = await connection.query('insert into STADIUM_PICS (STADIUM_ID,PIC) values (?,?)',
        [stadId, picture]);
  });
      connection.close();

  return true;
}

addTransactionInfo({User user, String info}) async {
  int userId = user.userId;
  final connection = await getConnection();
  await connection.query(
      'insert into TRANSACTION_INFO (USER_ID, TRANSACTION_INFO) values (?,?)',
      [userId, info]);
}

addToOrRemoveFromFav(
    {Player player, Stadium stadium, bool remove = false}) async {
  int playerId = player.id, stadiumId = stadium.id;
  final connection = await getConnection();
  if (remove) {
    print("remove stadium");
    await connection.query(
        'DELETE FROM `FAV_LIST` WHERE `PLAYER_ID` = ? AND STADIUM_ID = ?',
        [playerId, stadiumId]);
  } else {
    try {
      print("add stadium to fav");
      await connection.query(
          'insert into FAV_LIST (PLAYER_ID, STADIUM_ID) values (?,?)',
          [playerId, stadiumId]);
    } on MySqlException {
      print("dublicate record remove it");
      await connection.query(
          'DELETE FROM `FAV_LIST` WHERE `PLAYER_ID` = ? AND STADIUM_ID = ?',
          [playerId, stadiumId]);
    }
  }
}

addNewNotification({Player player, String notification}) async {
  int playerId = player.id;
  final connection = await getConnection();
  await connection.query(
      'insert into NOTIFICATIONS (PLAYER_ID, NOTIFICATION) values (?,?)',
      [playerId, notification]);
          connection.close();

}

addNewDateTimeBlock({DTBlock dateTimeBlock, Stadium stadium}) async {
  DateTime start = dateTimeBlock.start, end = dateTimeBlock.end;
  final connection = await getConnection();
  int confirmed = dateTimeBlock.confirmed ? 1 : 0, stadiumId = stadium.id;
  await connection.query(
      'insert into BLOCK_STADIUM (STADIUM_ID, START,END,CONFIRMED) values (?,?,?,?)',
      [stadiumId, start, end, confirmed]);
          connection.close();

}

addNewPost({int stadiumId, String post}) async {
  final connection = await getConnection();
  await connection.query(
      'insert into POSTS (STADIUM_ID, POST) values (?,?)', [stadiumId, post]);
          connection.close();

}

//oto
addDTBlockFormStadium({int playerId, int stadiumId, DTBlock dtBlock}) async {
  MySqlConnection connection = await getConnection();
  await connection.query(
      "insert into BLOCK_STADIUM (STADIUM_ID, PLAYER_ID, START, END,CONFIRMED ) values (?,?,?,?,?)",
      [
        stadiumId,
        playerId,
        dtBlock.start.toIso8601String(),
        dtBlock.end.toIso8601String(),
        0
      ]);
          connection.close();

}

//////////////  modify functions  ////////////////
///         Author: `Abdullah khaled`          ///
///  used to get out objects from database     ///
//////////////////////////////////////////////////
// UPDATE `table_name` SET `column_name` = `new_value' [WHERE condition];

changeAvatar({int userId, int avatarIndex}) async {
  final connection = await getConnection();
  print("IN CHANGE AVATAR: CAHNGEING THE AVATAR OF $userId to $avatarIndex ");
  await connection.query(
      "UPDATE USER SET PROFILE_PICTURE_INDEX = ? WHERE ID =?",
      [avatarIndex, userId]);
}

acceptDateTimeBlock({DTBlock dtBlock}) async {
  int dtBlockId = dtBlock.id;
  final connection = await getConnection();
  await connection.query(
      "UPDATE BLOCK_STADIUM SET CONFIRMED = ? WHERE ID =?", [1, dtBlockId]);
}

//////////////////////////////////////////////////
///           infromation functions            ///
///         Author: `Abdullah khaled`          ///
///  used to get out objects from database     ///
//////////////////////////////////////////////////

Future<bool> isInFav(Player user, Stadium stadium) async {
  final connection = await getConnection();
  Results result = await connection.query(
      "Select STADIUM_ID FROM FAV_LIST where PLAYER_ID=?",
      [stadium.id, user.id]);
  return result.elementAt(0)[0] != null;
}
