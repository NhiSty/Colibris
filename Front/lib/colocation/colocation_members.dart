import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/ColocMembers/colocMembers_service.dart';
import 'package:front/user/user.dart';
import 'package:front/website/share/secure_storage.dart';

class ColocationMembers extends StatelessWidget {
  final List<User> users;

  const ColocationMembers({super.key, required this.users});

  Future<void> _showDeleteConfirmationDialog(BuildContext context, user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('confirm_delete'.tr()),
          content: Text('ban_roommate_confirm'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('confirm'.tr()),
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
                onPressed: () async {
                  var userData = await decodeToken();

                  if (userData['user_id'] == users[index].id) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('ban_roommate_error'.tr()),
                          content: Text('ban_roommate_error_msg'.tr()),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ok'.tr()),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _showDeleteConfirmationDialog(context, users[index]);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                ),
                child: Text('ban_roommate_submit'.tr(),
                    style: const TextStyle(color: Colors.white))),
          );
        },
      ),
    );
  }
}
