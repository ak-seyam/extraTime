import 'package:extratime/myapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dto.dart';
import 'constants.dart';

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
                        widget.user.notifications[0],
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
                        this.widget.stadium.pics[0],
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
              print(
                  "inside onchange $results"); // TODO:remove this after debugging
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
    if (widget.user != null)
      isInFavList = (widget.user.favorites.indexOf(widget.stadium) != -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
              alignment: Alignment.bottomCenter,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.stadium.pics[0]),
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
                        "جدول الحجوزات المقبول:\n ${widget.stadium.timetable.join("\n")} \n",
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
                          onTap: () {
                            if (widget.user != null) {
                              setState(() {
                                isInFavList = (isInFavList) ? false : true;
                              });
                              if (isInFavList) {
                                print(
                                    "adding of user ${widget.user.userName} fav list stadium ${widget.stadium.name}");
                                widget.user.favorites.add(widget.stadium);
                                widget.user.notifications.insert(0,
                                    "تم إضافة ملعب \"${widget.stadium.name}\" الى المفضلات");
                              } else {
                                print(
                                    "removing of user ${widget.user.userName} fav list stadium ${widget.stadium.name}");
                                widget.user.favorites.remove(widget.stadium);
                                widget.user.notifications.insert(0,
                                    "تم حذف ملعب \"${widget.stadium.name}\" من المفضلات");
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "يتوجب التسجيل لكي تستطيع الحفظ في المفضلات"),
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
                    /*Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            print("location tapped!");
                          },
                          child: Container(
                            width: 50.0,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Icon(
                              Icons.location_on,
                              color: PRIMARY_COLOR_TEXT,
                            ),
                          ),
                        ))*/
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
                                print("${start.toString()}");
                                print("${end.toString()}");
                                bool variable = widget.user
                                    .book(start, end, widget.stadium);
                                print(variable);
                                if (variable) {
                                  widget.user.notifications.insert(0,
                                      "تم حجز معلب ${widget.stadium.name} بنجاح");
                                } else {
                                  widget.user.notifications.insert(0,
                                      "خطأ: لم يتم حجز المعلب,\n من فضلك قم بمراجعة الجدول واختر فترة غير مشغولة");
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

class UserProfile extends StatelessWidget {
  final User user;
  final Color primaryColor;
  UserProfile({@required this.primaryColor, @required this.user});
//TODO: add user fetching field
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
                      image: (user.profilePicture != null)
                          ? user.profilePicture
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
                      user: user,
                    );
                  }));
                },
                backgroundColor: this.primaryColor,
                child: Icon(Icons.edit),
              ),
            )
          ]),
          Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                user.name,
                style: TextStyle(
                    fontFamily: "Din",
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              )),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: user.personalInfo.length,
            itemBuilder: (context, index) {
              return CustomField(
                borderColor: PRIMARY_COLOR,
                text: user.personalInfo[index],
                textColor: PRIMARY_COLOR_TEXT,
              );
            },
          ),
          CustomRaisedButton(
            onTap: () {
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 37.0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  " اشعارات:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: "Din",
                  ),
                ),
                Icon(
                  Icons.notifications,
                  color: primaryColor,
                  size: 45,
                ),
              ],
            ),
          ),
          Divider(),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: user.notifications.length,
            itemBuilder: (context, index) {
              return CustomField(
                borderColor: primaryColor,
                text: user.notifications[index],
              );
            },
          )
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user;
  bool readyToGo = false;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerPassword =
      TextEditingController();
  String username, password;
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
                  onTap: () {},
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
                CustomRaisedButton(
                  onTap: () {
                    //TODO :if user is not a player
                    if (_textEditingController.text == "admin" &&
                        _textEditingControllerPassword.text == "admin") {
                      user = Player(
                          name: "abdullah",
                          password: "admin",
                          bookedStadiums: <Stadium>[samplesStadiums[0]],
                          favoritesList: <Stadium>[samplesStadiums[0]],
                          personalinfo: <String>["prop1", "prop2", "prop3"],
                          userName: "admin",
                          notifications: [
                            "notification 1",
                            "notification2",
                            "notification3"
                          ]);
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return MyApp(
                          user: user,
                        );
                      }), (d) => false);
                    } else if (_textEditingController.text == "admin2" &&
                        _textEditingControllerPassword.text == "admin2") {
                      user = Owner(
                          name: "صاحب الملعب 1",
                          password: "admin2",
                          personalinfo: ["معلومة 1", "info 2", "info3"],
                          staduims: [samplesStadiums[0]],
                          userName: "admin2");
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return ControlPanal(
                          user: user,
                        );
                      }), (x) => false);
                    } else {
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
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontFamily: "Din"),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                  text: "تسجيل الدخول",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NOSIGNINGINListOfStadiums()),
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
  CustomRaisedButton({@required this.onTap, @required this.text});
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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: user.stadiums.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListOfBlocks(stadium: user.stadiums[index]);
              }));
            },
            title: Text(user.stadiums[index].name),
          );
        },
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
                            widget.stadium.posts.add(tec.text);
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

class NOSIGNINGINListOfStadiums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListOfStadiums(
        borderColor: PRIMARY_COLOR,
        stadiums: samplesStadiums,
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
          image: image,
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
  final AssetImage image;
  final Player user;
  Avatar({@required this.image, @required this.user});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.user.profilePicture = image;
        Navigator.of(context).pop();
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: PRIMARY_COLOR),
            image: DecorationImage(image: image, fit: BoxFit.cover)),
      ),
    );
  }
}
