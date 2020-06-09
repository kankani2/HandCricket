import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:http/http.dart';

class SettingsPage extends StatefulWidget {
  final User currUser;

  SettingsPage({Key key, @required this.currUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(currUser);
}

class _SettingsPageState extends State<SettingsPage> {
  CarouselController buttonCarouselController = CarouselController();
  User currUser;
  bool _validate = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _SettingsPageState(this.currUser);

  int currentIndexForSlider = 0;
  final TextEditingController _usernameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = currUser.name;
    currentIndexForSlider = currUser.icon;
  }

  List<String> getIconList() {
    List<String> iconList = new List(iconMap.length);
    for (var key in iconMap.keys) {
      iconList[key] = iconMap[key];
    }
    return iconList;
  }

  goToPrevious() {
    buttonCarouselController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  _saveSettings() async {
    currUser.icon = currentIndexForSlider;

    var response = await put(url("/user/${currUser.uid}"),
        body: json.encode({"name": currUser.name, "icon": currUser.icon}));
    if (!isSuccess(response)) {
      final snackBar =
          SnackBar(content: Text('Database could not be updated.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    currUser.storeUserToDisk();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 70,
                child: TextField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  controller: _usernameController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (String name) {
                    if (_usernameController.text.trim().isEmpty) {
                      setState(() {
                        _validate = true;
                      });
                    } else {
                      setState(() {
                        _validate = false;
                      });
                      currUser.name = name;
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    iconSize: 80,
                    onPressed: goToPrevious,
                  ),
                  Expanded(
                    child: CarouselSlider(
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        initialPage: currUser.icon,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          currentIndexForSlider = index;
                        },
                      ),
                      items: getIconList().map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 8,
                                ),
                              ),
                              child: Image.asset(
                                image,
                                scale: 0.8,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    iconSize: 80,
                    onPressed: goToNext,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: FlatButton(
                  color: Colors.black,
                  child: Text(
                    'DONE',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  onPressed: _saveSettings,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
