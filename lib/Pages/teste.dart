import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/bpm_model.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final bpmModel = Provider.of<BpmModel>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Text(
          'Valor do bpm atualizado${bpmModel.bpm}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
