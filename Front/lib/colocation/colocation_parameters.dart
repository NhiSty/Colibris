import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/user/user_service.dart';

class ColocationSettingsPage extends StatelessWidget {
  const ColocationSettingsPage({super.key, required this.colocationId});
  final int colocationId;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer cette colocation ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () async {
                var res = await deleteColocation(colocationId);
                if (res == 200) {
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, '/home');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de la colocation'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Modifier la colocation'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/colocation_update',
                  arguments: {'colocationId': colocationId});
            },
          ),
          ListTile(
            title: const Text('Inviter un colocataire'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/create_invitation',
                  arguments: {'colocationId': colocationId});
            },
          ),
          ListTile(
            title: const Text('Exclure un colocataire'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              var res = await findUserInColoc(colocationId);
              if (res.isNotEmpty) {
                Navigator.pushNamed(context, '/colocation_members',
                    arguments: {'users': res});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Aucun colocataire à exclure'),
                ));
              }
            },
          ),
          ListTile(
            title: const Text('Supprimer la colocation'),
            textColor: Colors.red,
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
