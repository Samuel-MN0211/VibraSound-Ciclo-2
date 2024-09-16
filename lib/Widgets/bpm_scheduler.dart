import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/bpm_scheduler_model.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('BPM Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Eu quero que o BPM",
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "em",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "X bpm",
                        ),
                        onChanged: (value) {
                          _bpmChange = int.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "a cada",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Digite o intervalo (s)",
                        ),
                        onChanged: (value) {
                          _timeInterval = int.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "segundos",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      bool isIncrease = _selectedAction == 'Aumente';
                      int value =
                          isIncrease ? _bpmChange.abs() : -_bpmChange.abs();
                      bpmScheduler.activeScheduler(
                          value, _timeInterval, isIncrease);
                    },
                    child: const Text('Ativar Scheduler'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
