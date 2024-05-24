import 'package:flutter/material.dart';
import 'package:front/website/pages/backoffice/dialogs/add_user_dialog.dart';

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
          onPressed: () {
            showAddUserDialog(context);
          },
          child: const Text('Ajouter un utilisateur'),
        ),
      ],
    );
  }
}
