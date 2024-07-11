import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/main.dart';
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
          title: Text('confirm_delete'.tr()),
          content: Text('coloc_settings_delete_colocation_confirm'.tr()),
          backgroundColor: Colors.grey[850],
          titleTextStyle:  TextStyle(color: Colors.red[200], fontSize: 20),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr(), style: const TextStyle(color: Colors.amber)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('confirm'.tr(), style: TextStyle(color: Colors.red[200])),
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
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('coloc_settings_title'.tr()),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ListTile(
              title: Text('coloc_member'.tr(), style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () async {
                var res = await findUserInColoc(colocationId);
                if (res.isNotEmpty) {
                  Navigator.pushNamed(context, '/colocation_members_list',
                      arguments: {'users': res});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('coloc_settings_no_roommates'.tr()),
                    backgroundColor: Colors.blue,
                  ));
                }
              },
            ),
            ListTile(
              title: Text('coloc_settings_modify_colocation'.tr(), style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {
                Navigator.pushNamed(context, '/colocation_update',
                    arguments: {'colocationId': colocationId});
              },
            ),
            ListTile(
              title: Text('coloc_settings_invit_coloc_roommate'.tr(), style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {
                Navigator.pushNamed(context, '/create_invitation',
                    arguments: {'colocationId': colocationId});
              },
            ),
            ListTile(
              title: Text('coloc_settings_ban_coloc_roommate'.tr(), style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () async {
                var res = await findUserInColoc(colocationId);
                if (res.isNotEmpty) {
                  Navigator.pushNamed(context, '/colocation_members',
                      arguments: {'users': res});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('coloc_settings_no_roommates_to_ban'.tr()),
                    backgroundColor: Colors.blue,
                  ));
                }
              },
            ),
            ListTile(
              title: Text('coloc_settings_delete_colocation'.tr(), style: TextStyle(color: Colors.red[200])),
              trailing: Icon(Icons.delete, color: Colors.red[200]),
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
