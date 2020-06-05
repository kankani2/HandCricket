import 'package:flutter/material.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/select_icon.dart';

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
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'First Name',
                  style: TextStyle(
                    color: Colors.white,
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
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
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
