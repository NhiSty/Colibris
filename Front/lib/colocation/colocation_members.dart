import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/ColocMembers/colocMembers_service.dart';
import 'package:front/user/user.dart';
import 'package:front/website/share/secure_storage.dart';

class ColocationMembers extends StatefulWidget {
  final List<User> users;

  const ColocationMembers({super.key, required this.users});

  @override
  _ColocationMembersState createState() => _ColocationMembersState();
}

class _ColocationMembersState extends State<ColocationMembers> {
  late List<User> _users;

  @override
  void initState() {
    super.initState();
    _users = widget.users;
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, User user) async {
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
                  setState(() {
                    _users.removeWhere((u) => u.id == user.id);
                  });
                  if (!mounted) return;
                  Navigator.of(context).pop();
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
        title: Row(
          children: [
            const Icon(Icons.backspace_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'coloc_settings_ban_coloc_roommate'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    _users[index].firstname[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  _users[index].firstname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  _users[index].email,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    var userData = await decodeToken();
                    if (userData['user_id'] == _users[index].id) {
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
                      _showDeleteConfirmationDialog(context, _users[index]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'ban_roommate_submit'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
