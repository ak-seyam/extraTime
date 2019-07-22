import 'package:flutter/widgets.dart';
import 'extra_time_widgets.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'dto.dart';
class MyApp extends StatefulWidget {
  final Player user;
  final List<Stadium> stadiums;
  MyApp({@required this.user,this.stadiums});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static List<Stadium> _favList = List<Stadium>();
  
  var tabs;
  @override
  void initState(){
    super.initState();
    _favList = widget.user.favorites;
    print(_favList);
    tabs = {
      Tab(
        icon: Icon(Icons.home),
      ): CustomContentView(
          child: UserProfile(
        primaryColor: PRIMARY_COLOR,
        user: widget.user,
      )),
      Tab(
        icon: Icon(Icons.search),
      ): CustomContentView(
          child: ListOfStadiums(
        stadiums: widget.stadiums,
        borderColor: PRIMARY_COLOR,
        user: widget.user,
      )),
      Tab(
        icon: Icon(Icons.favorite),
      ): CustomContentView(
          child: ListOfStadiums(
        user: widget.user,
        stadiums: _favList,
        borderColor: PRIMARY_COLOR,
      )),
      Tab(icon: Icon(Icons.local_post_office)): CustomContentView(
        child: ListOfPosts(
          user: widget.user,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      user: widget.user,
      labelColorSelected: PRIMARY_COLOR,
      labelColorUnselected: PRIMARY_COLOR_TEXT,
      tabs: tabs,
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            "images/logo.png",
          ),
        ),
      ),
      indicatorDecoration: BoxDecoration(color: BACKGROUND),
    );
  }
}
