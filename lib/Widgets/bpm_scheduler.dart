import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/bpm_scheduler_model.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BpmScheduler extends StatefulWidget {
  const BpmScheduler({Key? key}) : super(key: key);

  @override
  _BpmSchedulerState createState() => _BpmSchedulerState();
}

class _BpmSchedulerState extends State<BpmScheduler> {
  String _selectedAction = 'Aumente';
  int _bpmChange = 0;
  int _timeInterval = 0;

  @override
  Widget build(BuildContext context) {
    final bpmScheduler = Provider.of<BpmSchedulerModel>(context, listen: false);
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const Text(
                "Eu quero que o BPM",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: DropdownButton<String>(
                  value: _selectedAction,
                  items: ['Aumente', 'Diminua'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAction = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "em",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "X bpm",
                  ),
                  onChanged: (value) {
                    _bpmChange = int.tryParse(value) ?? 0;
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "a cada",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 80,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "intervalo",
                  ),
                  onChanged: (value) {
                    _timeInterval = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "segundos",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF095169),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              onPressed: () {
                bool isIncrease = _selectedAction == 'Aumente';
                int value = isIncrease ? _bpmChange.abs() : -_bpmChange.abs();
                bpmScheduler.activeScheduler(value, _timeInterval, isIncrease);

                Navigator.pop(context, true);
                Fluttertoast.showToast(
                    msg: "Temporizador ativado",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color(0xFF095169),
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: const Text(
                'Ativar Temporizador',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
