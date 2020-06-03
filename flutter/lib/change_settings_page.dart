import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/user.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChangeSettingsPage extends StatefulWidget {
  final User currUser;

  ChangeSettingsPage({Key key, @required this.currUser}) : super(key: key);

  @override
  _ChangeSettingsPageState createState() => _ChangeSettingsPageState(currUser);
}

class _ChangeSettingsPageState extends State<ChangeSettingsPage> {
  CarouselController buttonCarouselController = CarouselController();
  User currUser;
  bool _validate = false;
  _ChangeSettingsPageState(this.currUser);
  int currentIndexForSlider = 0;
  final TextEditingController _usernameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = currUser.name;
    currentIndexForSlider = currUser.imageId;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    if (_usernameController.text.isEmpty ||
                        _usernameController.text.trim().isEmpty) {
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
                        initialPage: currUser.imageId,
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
                  onPressed: () {
                    currUser.imageId = currentIndexForSlider;
                    currUser.storeUserInfoToDisk();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
