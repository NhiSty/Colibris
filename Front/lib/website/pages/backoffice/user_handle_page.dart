import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/components/pagination_controls.dart';
import 'package:front/website/pages/backoffice/components/title_and_breadcrumb.dart';
import 'package:front/website/pages/backoffice/components/user_list.dart';

class UserHandlePage extends StatefulWidget {
  const UserHandlePage({super.key});

  @override
  _UserHandlePageState createState() => _UserHandlePageState();
}

class _UserHandlePageState extends State<UserHandlePage> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    setState(() {
      _futureUsers = UserService().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitleAndBreadcrumb(),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: _futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found'));
                  } else {
                    return UserList(
                        users: snapshot.data!, onUpdate: _fetchUsers);
                  }
                },
              ),
            ),
            const PaginationControls(),
          ],
        ),
      ),
    );
  }
}
