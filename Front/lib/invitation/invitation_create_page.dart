import 'package:flutter/material.dart';

class InvitationCreatePage extends StatefulWidget {
  @override
  _InvitationCreatePageState createState() => _InvitationCreatePageState();
}

class _InvitationCreatePageState extends State<InvitationCreatePage> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invitation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement invitation creation logic
                String email = _emailController.text;
                // Perform necessary actions with the email
              },
              child: Text('Create Invitation'),
            ),
          ],
        ),
      ),
    );
  }
}
