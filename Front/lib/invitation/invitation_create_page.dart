import 'package:flutter/material.dart';

class InvitationCreatePage extends StatefulWidget {
  const InvitationCreatePage({super.key});

  @override
  _InvitationCreatePageState createState() => _InvitationCreatePageState();
}

class _InvitationCreatePageState extends State<InvitationCreatePage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invitation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement invitation creation logic
                String email = _emailController.text;
                // Perform necessary actions with the email
              },
              child: const Text('Create Invitation'),
            ),
          ],
        ),
      ),
    );
  }
}
