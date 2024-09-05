import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Pages/home_page.dart';
import 'package:metronomo_definitivo/Widgets/samples.dart';
import 'package:metronomo_definitivo/Pages/teste.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Página inicial'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Samples'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Samples(),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Fechar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                    actionsPadding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 16.0),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Configurações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
