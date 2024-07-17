import 'package:flutter/material.dart';
import 'metronome_instance.dart';

void main() => runApp(const MetronomeApp());

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIBRASOM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF095169),
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Vibrasom',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontFamily: 'BellotaText',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const NavigationDrawer(),
      body: const MetronomeInstance(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF095169),
            ),
            child: Text(
              'Vibrasom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Metronome'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}






// class MetronomeScreen extends StatefulWidget {
//   const MetronomeScreen({super.key});

//   @override
//   _MetronomeScreenState createState() => _MetronomeScreenState();
// }

// class _MetronomeScreenState extends State<MetronomeScreen> {
//   int bpm = 150;
//   int compass = 1;
//   int batidas = 3;
//   bool isPlaying = false;

//   void _increaseBPM(int increment) {
//     setState(() {
//       bpm += increment;
//     });
//   }

//   void _decreaseBPM(int decrement) {
//     setState(() {
//       bpm -= decrement;
//     });
//   }

//   void _togglePlayPause() {
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildBPMButton(-10),
//               _buildBPMButton(-5),
//               Text(
//                 '$bpm BPM',
//                 style:
//                     const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//               ),
//               _buildBPMButton(5),
//               _buildBPMButton(10),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildCentralCircle(),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildSettingRow(
//                   'Compasso', compass, _increaseCompass, _decreaseCompass),
//               _buildSettingRow(
//                   'Batidas', batidas, _increaseBatidas, _decreaseBatidas),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.timer),
//                 onPressed: () {},
//                 iconSize: 40,
//               ),
//               IconButton(
//                 icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                 onPressed: _togglePlayPause,
//                 iconSize: 40,
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () {},
//                 iconSize: 40,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBPMButton(int value) {
//     return ElevatedButton(
//       onPressed: () {
//         if (value > 0) {
//           _increaseBPM(value);
//         } else {
//           _decreaseBPM(-value);
//         }
//       },
//       child: Text(value.toString()),
//     );
//   }

//   Widget _buildCentralCircle() {
//     return Container(
//       width: 200,
//       height: 200,
//       decoration: BoxDecoration(
//         color: Colors.teal,
//         shape: BoxShape.circle,
//       ),
//     );
//   }

//   Widget _buildSettingRow(
//       String label, int value, VoidCallback increment, VoidCallback decrement) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.remove),
//               onPressed: decrement,
//               iconSize: 30,
//             ),
//             Text(
//               value.toString(),
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: increment,
//               iconSize: 30,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   void _increaseCompass() {
//     setState(() {
//       compass += 1;
//     });
//   }

//   void _decreaseCompass() {
//     setState(() {
//       compass -= 1;
//     });
//   }

//   void _increaseBatidas() {
//     setState(() {
//       batidas += 1;
//     });
//   }

//   void _decreaseBatidas() {
//     setState(() {
//       batidas -= 1;
//     });
//   }
// }
