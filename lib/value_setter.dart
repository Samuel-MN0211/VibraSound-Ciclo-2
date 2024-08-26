import 'package:flutter/material.dart';

class ValueSetter extends StatefulWidget {
  final int value;
  final ValueChanged<int> onValueChanged;

  ValueSetter({required this.value, required this.onValueChanged});

  @override
  _ValueSetterState createState() => _ValueSetterState();
}

class _ValueSetterState extends State<ValueSetter> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() {
            _currentValue -= 1;
            widget.onValueChanged(_currentValue);
          }),
          icon: Icon(Icons.remove),
          iconSize: 28,
        ),
        Container(
          child: Text(
            '$_currentValue',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'BellotaText',
            ),
          ),
        ),
        IconButton(
          onPressed: () => setState(() {
            _currentValue += 1;
            widget.onValueChanged(_currentValue);
          }),
          icon: Icon(Icons.add),
          iconSize: 25,
        ),
      ],
    );
  }
}
