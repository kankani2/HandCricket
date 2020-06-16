import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiceWidget extends StatefulWidget {
  final _DiceWidgetState mState = new _DiceWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _DiceWidgetState extends State<DiceWidget> {
  bool _disable = true;
  Function(int) _callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getButtons(),
    );
  }

  disable() {
    setState(() {
      _disable = true;
    });
  }

  enable() {
    setState(() {
      _disable = false;
    });
  }

  registerCallback(Function(int) callback) {
    setState(() {
      _callback = callback;
    });
  }

  List<Expanded> _getButtons() {
    var diceIcons = new List<Expanded>();
    for (int i = 0; i < 6; i++) {
      diceIcons.add(
        Expanded(
          child: IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            icon: Image.asset(
              "images/dice/dice${i + 1}.png",
            ),
            splashColor: Colors.black,
            onPressed: _disable
                ? null
                : () {
                    _callback(i + 1);
                  },
          ),
        ),
      );
    }
    return diceIcons;
  }
}
