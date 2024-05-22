import 'package:flutter/material.dart';

class UserHandlePage extends StatelessWidget {
  const UserHandlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndBreadcrumb(),
            SizedBox(height: 16.0),
            Expanded(
              child: UserList(),
            ),
            PaginationControls(),
          ],
        ),
      ),
    );
  }
}

class TitleAndBreadcrumb extends StatelessWidget {
  const TitleAndBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Management',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, "/home");
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        ' > User Management',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const SearchBarAndAddUserButton(),
        ],
      ),
    );
  }
}

class SearchBarAndAddUserButton extends StatelessWidget {
  const SearchBarAndAddUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            onChanged: (value) {
              // @todo handle search text change here
            },
            decoration: const InputDecoration(
              hintText: 'Rechercher un utilisateur',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Ajouter un utilisateur'),
        ),
      ],
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredList = <User>[];
    return ListView.separated(
      itemCount: filteredList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final user = filteredList[index];
        return UserListItem(user: user);
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.username} - ${user.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.email),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // @todo for edit User
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // @todo for delete User
            },
          ),
        ],
      ),
    );
  }
}

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {},
          ),
          Text('1'),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// @todo need to replace here when everything is ok
class User {
  final String username;
  final String name;
  final String email;

  User({
    required this.username,
    required this.name,
    required this.email,
  });
}
