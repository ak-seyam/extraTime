import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

///
/// SERVER CONSTANTS
///
///Created!

/*You have successfully created a new database. The details are below.

Username: pgFQs6YlYL

Database name: pgFQs6YlYL

Password: O22SsEjXqt

Server: remotemysql.com

Port: 3306*/

String host = "remotemysql.com"; 
int port = 3306;
String dbUsername = "pgFQs6YlYL";
String dbAccPassword = "O22SsEjXqt";
String db = "pgFQs6YlYL";

/*
String host = "192.168.1.5"; 
int port = 3306;
String dbUsername = "user1";
String dbAccPassword = "user1";
String db = "user1";
*/
/*
List<Stadium> samplesStadiums = [
  Stadium(
      name: "ملعب اختبار",
      location: "مكان ما في العالم",
      otherInformations: "important information",
      phone: "010",
      pics: [
        "https://www.virginexperiencedays.co.uk/content/img/product/large/chelsea-football-club-stadium-02082318.JPG"
      ]),
  Stadium(
      name: "ملعب اختبار 2",
      location: "مكان ما في العالم",
      otherInformations: "important information",
      phone: "010",
      pics: [
        "https://pulse-static-files.s3.amazonaws.com/worldrugby/photo/2016/09/27/c397aa26-52da-49ba-b381-eaa280f96873/Tokyo_Stadium.jpg"
      ]),
  Stadium(
      name: "ملعب اختبار 3",
      location: "مكان ما في العالم",
      otherInformations: "important information",
      phone: "010",
      pics: [
        "https://pulse-static-files.s3.amazonaws.com/worldrugby/photo/2016/09/27/c397aa26-52da-49ba-b381-eaa280f96873/Tokyo_Stadium.jpg"
      ])
];
*/
//TODO:add connection exception return 
Future<MySqlConnection> getConnection() async {
  return MySqlConnection.connect(ConnectionSettings(
      db: db,
      host: host,
      port: port,
      password: dbAccPassword,
      user: dbUsername));
}

const PRIMARY_COLOR = Color(0xFF92d050);
const PRIMARY_COLOR_TEXT = Color(0xFF1f2617);
const PRIMARY_COLOR_2 = Color(0xFF5fa83d);
const BACKGROUND = Colors.white;
const SHADOW_COLOR = Color(0xFFd1d4cf);

const List<int> IMAGES = [0, 1, 2, 3,4];
