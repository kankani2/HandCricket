import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';

class JoinGamePage extends StatefulWidget {
  @override
  _JoinGamePage createState() => _JoinGamePage();
}

class _JoinGamePage extends State<JoinGamePage> {
  String gameCodeEntered = "";
  List<TextEditingController> textControllers =
      List.generate(codeWordLength, (i) => TextEditingController());

  List<Container> getTextFields(bool secondWord) {
    int start = 0;
    int end = (codeWordLength / 2).floor();
    if (secondWord) {
      start = (codeWordLength / 2).floor();
      end = codeWordLength - 1;
    }
    List<Container> containerList = new List<Container>();
    for (int i = start; i < end; i++) {
      containerList.add(
        Container(
          width: 53,
          height: 45,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: TextField(
            controller: textControllers[i],
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (String letter) {
              if (textControllers[i].text.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
      );
    }
    if (secondWord) {
      containerList.add(
        Container(
          width: 53,
          height: 45,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: TextField(
            controller: textControllers[codeWordLength - 1],
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      );
    }
    return containerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ENTER CODE:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: primaryfont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getTextFields(false),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getTextFields(true),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                color: Colors.blue[700],
                onPressed: () {
                  String code = "";
                  for (int i = 0; i < codeWordLength; i++) {
                    code += textControllers[i].text;
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
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
