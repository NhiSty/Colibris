import 'package:flutter/material.dart';
import 'package:front/ColocMembers/colocMembers_service.dart';
import 'package:front/user/user.dart';

class ColocationMembers extends StatelessWidget {
  final List<User> users;

  const ColocationMembers({super.key, required this.users});

  Future<void> _showDeleteConfirmationDialog(BuildContext context, user) async {
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
                var res = await deleteColocMember(user.colocMemberId!);
                if (res == 200) {
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, '/colocation_manage',
                      arguments: {'colocationId': user.colocationId});
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
    return Material(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].email),
            trailing: ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, users[index]);
                },
                child: Text('Kick', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                )),
          );
        },
      ),
    );
  }
}
