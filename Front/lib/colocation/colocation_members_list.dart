import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:colibris/main.dart';
import 'package:colibris/user/user.dart';

class ColocationMembersList extends StatelessWidget {
  final List<User> users;

  const ColocationMembersList({super.key, required this.users});
  static const routeName = "/colocation-members-list";

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.group, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'coloc_member'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey[800],
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
                      users[index].firstname[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    users[index].firstname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    users[index].email,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    "Score: ${users[index].score}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
