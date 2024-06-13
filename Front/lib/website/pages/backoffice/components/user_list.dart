import 'package:flutter/material.dart';
import 'package:front/user/user.dart';
import 'package:front/website/pages/backoffice/components/user_list_item.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final VoidCallback onUpdate;

  const UserList({super.key, required this.users, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final user = users[index];
        return UserListItem(user: user, onUpdate: onUpdate);
      },
    );
  }
}
