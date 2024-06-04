import 'package:flutter/material.dart';
import 'metronome_instance.dart';

class MultipleMetronomePage extends StatefulWidget {
  const MultipleMetronomePage({super.key});

  @override
  MultipleMetronomePageState createState() => MultipleMetronomePageState();
}

class MultipleMetronomePageState extends State<MultipleMetronomePage> {
  List<MetronomeInstance> _metronomes = [];

  @override
  void initState() {
    super.initState();
    _addMetronome();
  }

  void _addMetronome() {
    setState(() {
      _metronomes.add(MetronomeInstance(key: UniqueKey()));
    });
  }

  // Tornar o método público para acesso externo
  void removeMetronome(Key key) {
    setState(() {
      _metronomes.removeWhere((element) => element.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Metronomes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMetronome,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _metronomes.length,
        itemBuilder: (context, index) {
          return _metronomes[index];
        },
      ),
    );
  }
}
