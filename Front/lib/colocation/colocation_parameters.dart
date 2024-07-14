import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_members.dart';
import 'package:front/colocation/colocation_members_list.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/colocation/colocation_update.dart';
import 'package:front/home_screen.dart';
import 'package:front/invitation/invitation_create_page.dart';
import 'package:front/main.dart';
import 'package:front/user/user_service.dart';
import 'package:go_router/go_router.dart';

class ColocationSettingsPage extends StatelessWidget {
  const ColocationSettingsPage({super.key, required this.colocationId});
  final int colocationId;
  static const routeName = "/colocation-manage";

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('confirm_delete'.tr()),
          content: Text('coloc_settings_delete_colocation_confirm'.tr()),
          backgroundColor: Colors.grey[850],
          titleTextStyle: TextStyle(color: Colors.red[500], fontSize: 20),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr(),
                  style: const TextStyle(color: Colors.amber)),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: Text('confirm'.tr(),
                  style: TextStyle(color: Colors.red[500])),
              onPressed: () async {
                var res = await deleteColocation(colocationId);
                if (res == 204) {
                  if (!context.mounted) return;
                  context.push(HomeScreen.routeName);
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
              title: Text('coloc_member'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () async {
                var res = await findUserInColoc(colocationId);
                if (res.isNotEmpty) {
                  context.push(ColocationMembersList.routeName,
                      extra: {'users': res});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('coloc_settings_no_roommates'.tr()),
                    backgroundColor: Colors.blue,
                  ));
                }
              },
            ),
            ListTile(
              title: Text('coloc_settings_modify_colocation'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {
                context.push(ColocationUpdatePage.routeName,
                    extra: {'colocationId': colocationId});
              },
            ),
            ListTile(
              title: Text('coloc_settings_invit_coloc_roommate'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {
                context.push(InvitationCreatePage.routeName,
                    extra: {'colocationId': colocationId});
              },
            ),
            ListTile(
              title: Text('coloc_settings_ban_coloc_roommate'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () async {
                var res = await findUserInColoc(colocationId);
                if (res.isNotEmpty) {
                  context
                      .push(ColocationMembers.routeName, extra: {'users': res});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('coloc_settings_no_roommates_to_ban'.tr()),
                    backgroundColor: Colors.blue,
                  ));
                }
              },
            ),
            ListTile(
              title: Text('coloc_settings_delete_colocation'.tr(),
                  style: TextStyle(color: Colors.red[200], fontSize: 17)),
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
