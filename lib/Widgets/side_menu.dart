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
                MaterialPageRoute(builder: (context) => HomePage()),
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
                    content: const Samples(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fechar'),
                      ),
                    ],
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
