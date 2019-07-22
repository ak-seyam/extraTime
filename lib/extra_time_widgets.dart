import 'dart:async';

import 'package:extratime/daf.dart';
import 'package:extratime/myapp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dto.dart';
import 'constants.dart';
import 'dart:io';
import 'daf.dart';

//TODO: add stadiums gallery

class CustomScaffold extends StatelessWidget {
  final Map<Tab, Widget> tabs;
  final Widget title;
  final Color labelColorSelected, labelColorUnselected;
  final indicatorDecoration;
  final User user;

  CustomScaffold(
      {@required this.title,
      @required this.tabs,
      @required this.labelColorSelected,
      @required this.labelColorUnselected,
      @required this.user,
      this.indicatorDecoration});
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: tabs.keys.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            title: title,
            bottom: TabBar(
              tabs: tabs.keys.toList(),
              indicator: indicatorDecoration,
              labelColor: labelColorSelected,
              unselectedLabelColor: labelColorUnselected,
            ),
          ),
          body: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.right,
              color: labelColorSelected,
              child: TabBarView(
                children: tabs.values.toList(),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0.0,
            child: NotificationsBar(
              primaryColor: labelColorSelected,
              primaryDarkColor: labelColorUnselected,
              user: user,
            ),
          ),
        ),
      );
}

class NotificationsBar extends StatefulWidget {
  final primaryColor;
  final primaryDarkColor;
  final User user;
  NotificationsBar(
      {@required this.primaryColor,
      @required this.primaryDarkColor,
      @required this.user});
  @override
  _NotificationsBarState createState() => _NotificationsBarState();
}

class _NotificationsBarState extends State<NotificationsBar> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Notifications(
              user: widget.user,
              primaryColor: widget.primaryColor,
            );
          }));
        },
        child: Container(
            color: Colors.white,
            height: 60.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 5.0, 0),
                        child: Icon(
                          Icons.notifications,
                          color: widget.primaryColor,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        (widget.user.notifications != null &&
                                widget.user.notifications.isNotEmpty)
                            ? widget.user.notifications[0]
                            : "",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: "Din",
                          color: widget.primaryDarkColor,
                          fontSize: 18.0,
                        ),
                      ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class CustomContentView extends StatelessWidget {
  final Widget child;
  CustomContentView({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        Expanded(
          child: child,
        ),
        Divider()
      ],
    );
  }
}

class StadiumCard extends StatefulWidget {
  final Color borderColor;
  final Stadium stadium;
  final Player user;

  StadiumCard({@required this.user, this.stadium, this.borderColor});

  @override
  _StadiumCardState createState() => _StadiumCardState();
}

class _StadiumCardState extends State<StadiumCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: widget.borderColor)),
        height: 230.0,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MoreInfo(
                stadium: widget.stadium,
                primaryColor: widget.borderColor,
                user: widget.user,
              );
            }));
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        this.widget.stadium.pics.isNotEmpty
                            ? this.widget.stadium.pics[0]
                            : "http://www.polyplastic-piscine-34.com/images/no-images/no-image.jpg",
                      ),
                      fit: BoxFit.fitWidth),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.stadium.name,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontFamily: "Din", fontSize: 25.0),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "رقم الهاتف: ${widget.stadium.phone}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontFamily: "Din"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "العنوان: ${widget.stadium.location}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontFamily: "Din"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfStadiums extends StatefulWidget {
  final List<Stadium> stadiums;
  final Color borderColor;
  final Player user;
  ListOfStadiums(
      {this.user, @required this.stadiums, @required this.borderColor});

  @override
  _ListOfStadiumsState createState() => _ListOfStadiumsState();
}

class _ListOfStadiumsState extends State<ListOfStadiums> {
  List<Stadium> results;
  TextEditingController tec = TextEditingController();
  @override
  void initState() {
    results = []..addAll(widget.stadiums);
    print("${widget.stadiums}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          child: TextField(
            controller: tec,
            onChanged: (stadiumName) {
              setState(() {
                print("inside setstate");
                results = widget.stadiums
                    .where((stadium) => stadium.name.contains(tec.text))
                    .toList();
                print(results); //Doesn't get executed!
              });
            },
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              return StadiumCard(
                stadium: results[index],
                borderColor: widget.borderColor,
                user: widget.user,
              );
            },
          ),
        ),
      ],
    );
  }
}

class MoreInfo extends StatefulWidget {
  final Stadium stadium;
  final Color primaryColor;
  final Player user;

  MoreInfo({@required this.stadium, @required this.primaryColor, this.user});

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  bool isInFavList = false;
  @override
  void initState() {
    if (widget.user != null) {
      widget.user.favorites.forEach((favstadium) {
        if (favstadium.toString() == widget.stadium.toString())
          isInFavList = true;
      });
      print(("is in fav list: $isInFavList"));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("stadiums ${widget.stadium.timetable}");
    return Scaffold(
      body: Column(
        children: <Widget>[
          GestureDetector(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ImagesGallery(pics: widget.stadium.pics.isNotEmpty?widget.stadium.pics:["http://www.polyplastic-piscine-34.com/images/no-images/no-image.jpg"]);
            }));
          },
                      child: Stack(
                alignment: Alignment.bottomCenter,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.stadium.pics.isNotEmpty
                                ? widget.stadium.pics[0]
                                : "http://www.polyplastic-piscine-34.com/images/no-images/no-image.jpg"),
                            fit: BoxFit.fitWidth)),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(1, -1),
                            end: Alignment(1, 1),
                            colors: <Color>[
                          Color.fromARGB(0, 0, 0, 0),
                          Color.fromARGB(150, 0, 0, 0)
                        ])),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      this.widget.stadium.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Din",
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomField(
                    text: "رقم التليفون: ${widget.stadium.phone}",
                    borderColor: widget.primaryColor,
                  ),
                  CustomField(
                    text: "العنوان: ${widget.stadium.location}",
                    borderColor: widget.primaryColor,
                  ),
                  CustomField(
                    text:
                        "جدول الحجوزات:\n ${widget.stadium.timetable.reversed.join("\n")} \n",
                    borderColor: widget.primaryColor,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () async {
                            if (widget.user != null) {
                              setState(() {
                                isInFavList = !isInFavList;
                              });

                              if (isInFavList) {
                                print(
                                    "player= ${widget.user}, playerId = ${widget.user.id}");

                                await addToOrRemoveFromFav(
                                    player: widget.user,
                                    stadium: widget.stadium);
                                print(
                                    "fav after addition ${widget.user.favorites}");
                                //! Maybe adding await would fix it ?
                                await addNewNotification(
                                    player: widget.user,
                                    notification:
                                        "تم إضافة ملعب \"${widget.stadium.name}\" الى المفضلات");
                                setState(() {
                                  widget.user.addToFav(widget.stadium);
                                  widget.user.notifications.add(
                                      "تم إضافة ملعب \"${widget.stadium.name}\" الى المفضلات");
                                });
                              } else {
                                print("in else statement");
                                print(
                                    "player= ${widget.user}, playerId = ${widget.user.id}");

                                await addToOrRemoveFromFav(
                                    player: widget.user,
                                    stadium: widget.stadium,
                                    remove: true);
                                await addNewNotification(
                                    player: widget.user,
                                    notification:
                                        "تم حذف ملعب \"${widget.stadium.name}\" من المفضلات");
                                setState(() {
                                  print(
                                      "index of: ${widget.user.favorites.indexOf(widget.stadium)}");
                                  Stadium tempFav = Stadium();
                                  widget.user.favorites.forEach((stadium) {
                                    if (stadium.toString() ==
                                        widget.stadium.toString()) {
                                      tempFav = stadium;
                                    }
                                  });
                                  widget.user.favorites.remove(tempFav);
                                  widget.user.notifications.add(
                                      "تم حذف ملعب \"${widget.stadium.name}\" من المفضلات");
                                });
                                print(
                                    "has been removed? ${widget.user.favorites}");
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "يتوجب التسجيل لكي تستطيع الحجز"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("سجل الدخول"),
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()),
                                                  (x) => false);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("اغلاق"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                          },
                          child: Container(
                            width: 50.0,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Icon(
                              Icons.favorite,
                              color: (isInFavList)
                                  ? PRIMARY_COLOR
                                  : PRIMARY_COLOR_TEXT,
                            ),
                          )),
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            if (widget.user != null) {
                              DateTime pickedDateStart = await showDatePicker(
                                  firstDate: DateTime(2019, 1),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                  context: context);
                              TimeOfDay pickedTimeStart = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              DateTime start;
                              if (pickedDateStart != null ||
                                  pickedTimeStart != null) {
                                start = DateTime(
                                    pickedDateStart.year,
                                    pickedDateStart.month,
                                    pickedDateStart.day,
                                    pickedTimeStart.hour,
                                    pickedTimeStart.minute);
                              }

                              DateTime pickedDateEnd = await showDatePicker(
                                  firstDate: DateTime(2019, 1),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                  context: context);
                              TimeOfDay pickedTimeEnd = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              DateTime end;
                              if (pickedDateEnd != null ||
                                  pickedTimeEnd != null)
                                end = DateTime(
                                    pickedDateEnd.year,
                                    pickedDateEnd.month,
                                    pickedDateEnd.day,
                                    pickedTimeEnd.hour,
                                    pickedTimeEnd.minute);

                              if (pickedDateEnd != null ||
                                  pickedDateStart != null ||
                                  pickedTimeEnd != null ||
                                  pickedTimeStart != null) {
                                print("starting date: ${start.toString()}");
                                print("ending date: ${end.toString()}");
                                bool variable;
                                setState(() {
                                  print("BOOKING");
                                  variable = widget.user
                                      .book(start, end, widget.stadium);
                                });

                                print(variable);
                                if (variable) {
                                  setState(() {
                                    widget.user.notifications.insert(0,
                                        "تم حجز معلب ${widget.stadium.name} بنجاح");
                                  });

                                  addNewNotification(
                                      player: widget.user,
                                      notification:
                                          "تم حجز معلب ${widget.stadium.name} بنجاح");
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "تم حجز معلب ${widget.stadium.name} بنجاح"),
                                        );
                                      });
                                } else {
                                  setState(() {
                                    widget.user.notifications.insert(0,
                                        "خطأ: لم يتم حجز المعلب,\n من فضلك قم بمراجعة الجدول واختر فترة غير مشغولة");
                                  });

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "خطأ: لم يتم حجز المعلب,\n من فضلك قم بمراجعة الجدول واختر فترة غير مشغولة"),
                                        );
                                      });
                                }
                              } else {
                                print("user has canceled his request!");
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "يتوجب التسجيل لكي تستطيع الحجز"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("سجل الدخول"),
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()),
                                                  (x) => false);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("اغلاق"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                          },
                          child: Container(
                            width: 50.0,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Icon(
                              Icons.check,
                              color: PRIMARY_COLOR_TEXT,
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  final User user;
  final Color primaryColor;
  UserProfile({@required this.primaryColor, @required this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget personalInfo;
  @override
  void initState() {
    super.initState();
    print("USER INFO ${widget.user.personalInfo}\n is empty ${widget.user.personalInfo.isEmpty}\n first element equals nothing ${widget.user.personalInfo[0]==""}");

    personalInfo = (widget.user.personalInfo != null &&
            widget.user.personalInfo.isNotEmpty && widget.user.personalInfo[0]!="")
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.user.personalInfo.length,
            itemBuilder: (context, index) {
              return CustomField(
                borderColor: PRIMARY_COLOR,
                text: widget.user.personalInfo[index],
                textColor: PRIMARY_COLOR_TEXT,
              );
            },
          )
        : Text("عفوًا لا توجد معلومات شخصية",style: TextStyle(fontFamily: "Din"),textDirection: TextDirection.rtl,);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(alignment: Alignment.bottomLeft, children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: (widget.user.profilePicture != null)
                          ? widget.user.profilePicture
                          : AssetImage("images/user.png"),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: 45,
              width: 45,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChooseAvatar(
                      user: widget.user,
                    );
                  }));
                },
                backgroundColor: this.widget.primaryColor,
                child: Icon(Icons.edit),
              ),
            )
          ]),
          Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                widget.user.name,
                style: TextStyle(
                    fontFamily: "Din",
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              )),
          personalInfo,
          CustomRaisedButton(
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (x) => false);
            },
            text: "تسجيل الخروج",
          )
        ],
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final String text;
  final Color borderColor;
  final textColor;
  CustomField(
      {@required this.text,
      @required this.borderColor,
      this.textColor = const Color(0xFF1f2617)});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border.all(color: borderColor, width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              text,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontFamily: "Din"),
                            ),
                          );
                        });
                  },
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Din",
                        color: textColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Notifications extends StatelessWidget {
  final User user;
  final primaryColor;
  Notifications({@required this.primaryColor, @required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اشعارات"),),
      body: 
          ListView.builder(
              
              itemCount: user.notifications.length,
              itemBuilder: (context, index) {
                return CustomField(
                  borderColor: primaryColor,
                  text: user.notifications[index],
                );
              },
            )  
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user;
  bool asAdmin = false;
  bool readyToGo = false;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerPassword =
      TextEditingController();
  String username, password;

  _connectionTest(context) async {
    try {
      var result = await InternetAddress.lookup('google.com');
    } on SocketException {
      Timer(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }), (x) => false);
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("تأكد من اتصالك بالانترنت ثم قم بإعادة المحاولة"),
            );
          });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textEditingControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("images/logo.png"),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: "Din"),
                      labelText: "اسم المستخدم",
                      prefixIcon: Icon(Icons.account_circle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 1.0))),
                  controller: _textEditingController,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: "Din"),
                      labelText: "كلمة المرور",
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 1.0))),
                  obscureText: true,
                  controller: _textEditingControllerPassword,
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("سجل حساب جديد كـ"),
                            actions: <Widget>[
                              GestureDetector(
                                child: Text("سجل كلاعب"),
                                onTap: () {
                                  _connectionTest(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignUpAsPlayer();
                                  }));
                                },
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _connectionTest(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpAsOwner()));
                                  },
                                  child: Text("سجل كصاحب ملاعب"))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("سجل حساب جديد  ",
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              fontFamily: "Din",
                              fontWeight: FontWeight.w700)),
                      Text(
                        "ليس لديك حساب؟",
                        style: TextStyle(fontFamily: "Din"),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "التسجيل كمدير ملاعب",
                      style: TextStyle(fontFamily: "Din"),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: PRIMARY_COLOR,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: asAdmin,
                      onChanged: (newValue) {
                        setState(() {
                          asAdmin = newValue;
                          print(asAdmin);
                        });
                      },
                    ),
                  ],
                ),
                CustomRaisedButton(
                  onTap: () async {
                    _connectionTest(context);
                    if (_textEditingController.text == "" ||
                        _textEditingControllerPassword.text == "") {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("ادخل اسم المستخدم/ كلمة المرور"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("اغلاق"),
                                  )
                                ],
                              ));
                    } else {
                      if (asAdmin) {
                        Owner res = await getOwner(
                            password:
                                _textEditingControllerPassword.text.trim(),
                            username: _textEditingController.text.trim());
                        print("owner : $res");
                        if (res != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ControlPanal(
                                        user: res,
                                      )),
                              (x) => false);
                        } else {
                          wrongUserNameOrPassword(context);
                        }
                      } else {
                        Player res = await getPlayer(
                            password:
                                _textEditingControllerPassword.text.trim(),
                            username: _textEditingController.text.trim());
                        print("INSIDE GETTING PLAYER $res");
                        if (res != null) {
                          print("user nickname: ${res.favorites}");
                          List<Stadium> temp = await getListOfStadiums();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyApp(
                                        user: res,
                                        stadiums: temp,
                                      )),
                              (x) => false);
                          print("sent user${res.id}");
                        } else {
                          wrongUserNameOrPassword(context);
                        }
                      }
                    }
                  },
                  text: "تسجيل الدخول",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: GestureDetector(
                      onTap: () async {
                        _connectionTest(context);
                        List<Stadium> stadiums = await getListOfStadiums();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NOSIGNINGINListOfStadiums(
                                      stadiums: stadiums,
                                    )),
                            (x) => false);
                      },
                      child: Text("او اذهب لقائمة الملاعب بدون تسجيل",
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Din"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  CustomRaisedButton({@required this.onTap, @required this.text, key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(20.0),
        width: 140,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: SHADOW_COLOR,
                  blurRadius: 2,
                  offset: Offset.fromDirection(1.0, 3.0))
            ],
            borderRadius: BorderRadius.circular(28.0),
            gradient: LinearGradient(
                colors: <Color>[PRIMARY_COLOR, PRIMARY_COLOR_2],
                begin: Alignment(-1, 1),
                end: Alignment(1, 1))),
        height: 50,
        child: Center(
          child: Text(
            text,
            style:
                TextStyle(color: Colors.white, fontFamily: "Din", fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class ControlPanal extends StatelessWidget {
  final Owner user;
  ControlPanal({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (x) => false);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: PRIMARY_COLOR_TEXT,
                ),
              ))
        ],
        elevation: 1.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Image.asset("images/logo.png")),
        ),
      ),
      body: ListOfStadiumsControlPanel(
        user: user,
      ),
    );
  }
}

class ListOfStadiumsControlPanel extends StatelessWidget {
  final Owner user;
  ListOfStadiumsControlPanel({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (user.stadiums != null)
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: user.stadiums.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    print("${user.stadiums[index]}");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ListOfBlocks(stadium: user.stadiums[index]);
                    }));
                  },
                  title: Text(user.stadiums[index].name),
                );
              },
            )
          : Text(""),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddStadiumRoute(owner: user)));
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddStadiumRoute extends StatefulWidget {
  final Owner owner;
  AddStadiumRoute({@required this.owner});
  @override
  _AddStadiumRouteState createState() => _AddStadiumRouteState();
}

class _AddStadiumRouteState extends State<AddStadiumRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, location, phone;
  List<String> pics = List<String>(), posts = List<String>();
  DTBlock dtblock;
  int countPics = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اضف ملعب جديد"),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            print("THE OWNER IS ${widget.owner}");
            if (await addNewStadium(
                location: location,
                name: name,
                owner: widget.owner,
                phone: phone,
                pics: pics)) {
              Navigator.of(context).pop();
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          "يوجد معلب في هذا المكان بالفعل او ان خطأ غير متوقع قد حدث"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("اغلاق"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          }
        },
        child: Container(
          height: 100,
          color: PRIMARY_COLOR,
          child: Center(
            child: Text(
              "Done".toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: "name",
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.0, color: PRIMARY_COLOR_2))),
                onSaved: (value) => this.name = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "location",
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.0, color: PRIMARY_COLOR_2))),
                onSaved: (value) => this.location = value,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                decoration: InputDecoration(
                    labelText: "phone",
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.0, color: PRIMARY_COLOR_2))),
                onSaved: (value) => this.phone = value,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      countPics++;
                    });
                  },
                  child: Center(
                    child: Icon(Icons.add),
                  )),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: countPics,
                itemBuilder: (context, index) {
                  return TextFormField(
                    decoration: InputDecoration(
                        labelText: "pics",
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.0, color: PRIMARY_COLOR_2))),
                    onSaved: (value) {
                      if (value != null) this.pics.add(value);
                      print(pics);
                      setState(() {
                        countPics++;
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfBlocks extends StatefulWidget {
  final Stadium stadium;

  ListOfBlocks({@required this.stadium});

  @override
  _ListOfBlocksState createState() => _ListOfBlocksState();
}

class _ListOfBlocksState extends State<ListOfBlocks> {
  TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("time table: ${widget.stadium.timeTable}");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        tooltip: "اكتب رسالة",
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          if ((tec.text != null || tec.text != " ")) {
                            widget.stadium.writePost(tec.text);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("ارسال"),
                      ),
                      FlatButton(
                        child: Text("اغلاق"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text("اكتب رسالة"),
                          TextField(
                            controller: tec,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: PRIMARY_COLOR, width: 1.0))),
                            keyboardType: TextInputType.multiline,
                            maxLines: 20,
                          ),
                        ],
                      ),
                    ),
                  ));
        },
        child: Icon(Icons.local_post_office),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.stadium.timetable.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            block: widget.stadium.timetable[index],
          );
        },
      ),
    );
  }
}

class CustomListTile extends StatefulWidget {
  final DTBlock block;
  CustomListTile({@required this.block});
  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text(
              "${(widget.block.confirmed) ? "مؤكد" : "تأكيد"}",
              style: TextStyle(color: PRIMARY_COLOR),
              textDirection: TextDirection.rtl,
            ),
            onPressed: () {
              if (!widget.block.confirmed)
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("هل انت متأكد انك تريد تأكيد الحجز؟"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("تأكيد"),
                            onPressed: () {
                              widget.block.confirmed = true;
                              print(
                                  "widget.block.confirmed = ${widget.block.confirmed}");
                              acceptDateTimeBlock(dtBlock: widget.block);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
            },
          ),
          Expanded(
            child: Text("${widget.block.toString()}"),
          )
        ],
      ),
    );
  }
}

class NOSIGNINGINListOfStadiums extends StatefulWidget {
  final List<Stadium> stadiums;
  NOSIGNINGINListOfStadiums({@required this.stadiums});
  @override
  _NOSIGNINGINListOfStadiumsState createState() =>
      _NOSIGNINGINListOfStadiumsState();
}

class _NOSIGNINGINListOfStadiumsState extends State<NOSIGNINGINListOfStadiums> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListOfStadiums(
        borderColor: PRIMARY_COLOR,
        stadiums: widget.stadiums,
      ),
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (x) => false);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle,
                  color: PRIMARY_COLOR_TEXT,
                ),
              ))
        ],
        elevation: 1.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Image.asset("images/logo.png")),
        ),
      ),
    );
  }
}

class ListOfPosts extends StatefulWidget {
  final Player user;

  ListOfPosts({@required this.user});

  @override
  _ListOfPostsState createState() => _ListOfPostsState();
}

class _ListOfPostsState extends State<ListOfPosts> {
  List<String> posts = List<String>();
  @override
  void initState() {
    widget.user.favorites.forEach((stadium) {
      stadium.posts.forEach((post) {
        posts.add("${stadium.name}:\n$post");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
              border: Border.all(color: PRIMARY_COLOR, width: 1.0)),
          child: Text(
            posts[index],
            textDirection: TextDirection.rtl,
            style: TextStyle(color: PRIMARY_COLOR_TEXT),
          ),
        );
      },
    );
  }
}

class ChooseAvatar extends StatefulWidget {
  final Player user;
  ChooseAvatar({@required this.user});

  @override
  _ChooseAvatarState createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {
  List<Avatar> avatars = List<Avatar>();
  @override
  void initState() {
    IMAGES.forEach((image) => avatars.add(Avatar(
          user: widget.user,
          imageIndex: image,
        )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose avatar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 4,
          children: avatars,
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final int imageIndex;
  final Player user;

  Avatar({@required this.imageIndex, @required this.user});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.user.setProfilePicture(imageIndex);
        Navigator.of(context).pop();
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: PRIMARY_COLOR),
            image: DecorationImage(
                image: AssetImage("images/$imageIndex.png"),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class SignUpAsPlayer extends StatefulWidget {
  @override
  _SignUpAsPlayerState createState() => _SignUpAsPlayerState();
}

class _SignUpAsPlayerState extends State<SignUpAsPlayer> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var name, password, username, moreinfo;
  String errorMsg = "";
  submit() async {
    FormState fs = _formkey.currentState;
    if (fs.validate()) {
      fs.save();

      if (!await addNewPlayer(
          name: name,
          password: password,
          username: username,
          personalInfo: moreinfo)) {
        setState(() {
          errorMsg = "البيانات المدخلة غير صحيحة";
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    "تم تسجيل الحساب $username بنجاح وسيتم تحويلك الى صفحة تسجيل الدخول خلال بضع ثوان"),
              );
            });
        Timer(Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (x) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          margin: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                        labelText: "اسم المستخدم"),
                    validator: (value) =>
                        value.isEmpty ? "ادخل اسم المستخدم" : null,
                    onSaved: (value) => username = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (value) => password = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                        labelText: "كلمة السر"),
                    obscureText: true,
                    validator: (value) =>
                        value.isEmpty ? "ادخل كلمة المرور" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (value) => name = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                        labelText: "الاسم المستعار"),
                    validator: (value) =>
                        value.isEmpty ? "ادخل الاسم المستعار" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (value) => moreinfo = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                        labelText: "معلومات اضافية (اخياري)"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                CustomRaisedButton(
                  onTap: submit,
                  text: "تسجيل الحساب",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpAsOwner extends StatefulWidget {
  @override
  _SignUpAsOwnerState createState() => _SignUpAsOwnerState();
}

class _SignUpAsOwnerState extends State<SignUpAsOwner> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var name, password, username, moreinfo;
  String errorMsg = "";
  submit() async {
    FormState fs = _formkey.currentState;
    if (fs.validate()) {
      fs.save();

      if (!await addNewOwner(
          name: name,
          password: password,
          username: username,
          personalInfo: moreinfo)) {
        setState(() {
          errorMsg = "البيانات المدخلة غير صحيحة";
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    "تم تسجيل الحساب $username بنجاح وسيتم تحويلك الى صفحة تسجيل الدخول خلال بضع ثوان"),
              );
            });
        Timer(Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (x) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                  labelText: "اسم المستخدم"),
              validator: (value) => value.isEmpty ? "ادخل اسم المستخدم" : null,
              onSaved: (value) => username = value,
            ),
            TextFormField(
              onSaved: (value) => password = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                  labelText: "كلمة السر"),
              obscureText: true,
              validator: (value) => value.isEmpty ? "ادخل كلمة المرور" : null,
            ),
            TextFormField(
              onSaved: (value) => name = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                  labelText: "الاسم المستعار"),
              validator: (value) =>
                  value.isEmpty ? "ادخل الاسم المستعار" : null,
            ),
            TextFormField(
              onSaved: (value) => moreinfo = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: PRIMARY_COLOR_2, width: 1.0)),
                  labelText: "معلومات اضافية (اخياري)"),
            ),
            Text(errorMsg),
            CustomRaisedButton(
              onTap: submit,
              text: "تسجيل الحساب",
            )
          ],
        ),
      ),
    );
  }
}

wrongUserNameOrPassword(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "خطأ في اسم المستخدم او كلمة المرور",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "اغلاق",
                textDirection: TextDirection.rtl,
                style: TextStyle(color: PRIMARY_COLOR, fontFamily: "Din"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

class ImagesGallery extends StatelessWidget {
  final List<String> pics;
  ImagesGallery({@required this.pics});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصور"),
      ),
      body: ListView.builder(
        itemCount: pics.length,
        itemBuilder: (context, index) {
          return Container(margin: EdgeInsets.all(16.0),
            height: 200,
            decoration: BoxDecoration(border: Border.all(color: PRIMARY_COLOR_2,width: 1.0),
                image: DecorationImage(
                    image: NetworkImage(pics[index]), fit: BoxFit.cover)),
          );
        },
      ),
    );
  }
}
