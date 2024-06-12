import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/user/components/user_list_item.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      itemCount: users.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final user = users[index];
        return Center(
          child: UserListItem(
            user: user,
          ),
        );
      },
    );
  }
}
