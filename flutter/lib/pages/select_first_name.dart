import 'package:flutter/material.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/pages/select_icon.dart';

class SelectFirstNamePage extends StatefulWidget {
  @override
  _SelectFirstNamePageState createState() => _SelectFirstNamePageState();
}

class _SelectFirstNamePageState extends State<SelectFirstNamePage> {
  bool _validate = false;
  final _textEditingController = TextEditingController();

  void _onNameSubmit(String username) {
    if (_textEditingController.text.trim().isEmpty) {
      setState(() {
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SelectIconPage(
                  name: username,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'First Name',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 60,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 70,
              child: TextField(
                controller: _textEditingController,
                cursorColor: yellowColor,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: blackColor,
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellowColor, width: 5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellowColor, width: 5),
                  ),
                ),
                onSubmitted: _onNameSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
