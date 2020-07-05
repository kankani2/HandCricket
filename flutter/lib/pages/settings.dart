import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/utils/error.dart';

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

    var response = await request(HttpMethod.PUT, "/user/${currUser.uid}",
        body: {"name": currUser.name, "icon": currUser.icon});
    if (!isSuccess(response)) {
      errorMessage(_scaffoldKey, 'Database could not be updated.');
      return;
    }

    currUser.storeUserToDisk();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 70,
              child: TextField(
                cursorColor: blackColor,
                maxLength: maxNameLength,
                maxLengthEnforced: true,
                keyboardType: TextInputType.text,
                controller: _usernameController,
                style: TextStyle(
                  color: blackColor,
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  labelStyle: TextStyle(
                    color: blackColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellowColor, width: 5),
                  ),
                  hintText: 'Nickname',
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
                                color: yellowColor,
                                width: 5,
                              ),
                            ),
                            child: Image.asset(
                              image,
                              color: blackColor,
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
                  style: TextStyle(fontSize: 30, color: yellowColor),
                ),
                onPressed: _saveSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
