import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:colibris/services/user_service.dart';
import 'package:colibris/website/pages/backoffice/user/components/user_list_item.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (users.isEmpty) {
      return Center(child: Text('backoffice_users_no_user'.tr()));
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
