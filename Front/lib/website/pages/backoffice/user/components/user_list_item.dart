import 'package:flutter/material.dart';
import 'package:colibris/services/user_service.dart';
import 'package:colibris/website/pages/backoffice/user/dialogs/users/delete_user_dialog.dart';
import 'package:colibris/website/pages/backoffice/user/dialogs/users/edit_user_dialog.dart';
import 'package:colibris/website/share/secure_storage.dart';

class UserListItem extends StatefulWidget {
  final User user;

  UserListItem({super.key, required this.user});

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  var userData = {};

  @override
  void initState() {
    fetchUserData() async {
      var user = await decodeToken();
      setState(() {
        userData = user;
      });
    }

    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.8;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.blue[800]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.user.firstname} ${widget.user.lastname}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(widget.user.email),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[800]),
                onPressed: () {
                  showEditUserDialog(context, widget.user);
                },
              ),
              userData['user_id'] == widget.user.id
                  ? const SizedBox(width: 16)
                  : IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[800],
                      ),
                      onPressed: () {
                        showDeleteUserDialog(context, widget.user);
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
