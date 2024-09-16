import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Widgets/bpm_scheduler.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BpmScheduler(),
    );
  }
}
