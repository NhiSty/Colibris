import 'package:flutter/material.dart';

class ColocationSettingsPage extends StatelessWidget {
  const ColocationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres de la colocation'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Paramètre 1'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // montrer un pop-up pour le paramètre 1
              Navigator.pushNamed(context, '/parametre1');
            },
          ),
          ListTile(
            title: const Text('Paramètre 2'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Ajoutez votre logique ici pour le paramètre 2
            },
          ),
          // Ajoutez plus de paramètres ici
        ],
      ),
    );
  }
}
