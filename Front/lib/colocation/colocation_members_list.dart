import 'package:flutter/material.dart';
import 'package:front/user/user.dart';

class ColocationMembersList extends StatelessWidget {
  final List<User> users;

  const ColocationMembersList({super.key, required this.users});
  static const routeName = "/colocation-members-list"; 

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0), // Add margin around each card
            child: ListTile(
              title: Text(
                users[index].firstname,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold, // Set the font weight of the name
                ),
              ),
              subtitle: Text(
                users[index].email,
                style: const TextStyle(
                  fontStyle:
                      FontStyle.italic, // Set the font style of the email
                ),
              ),
              trailing: Text(
                "Score: ${users[index].score}",
                style: const TextStyle(
                  color: Colors.green, // Set the color of the score
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
