import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/share/secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lastnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEditingLastName = false;
  bool _isEditingFirstName = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  bool get _isAnyFieldEditing => [
        _isEditingLastName,
        _isEditingFirstName,
        _isEditingEmail,
        _isEditingPassword
      ].any((isEditing) => isEditing);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      var user = await decodeToken();
      int userId = user['user_id'];
      final userService = UserService();
      final userData = await userService.getUserById(userId);
      setState(() {
        _lastnameController.text = userData['Lastname'] ?? '';
        _firstNameController.text = userData['Firstname'] ?? '';
        _emailController.text = userData['Email'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'User Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildEditableRow(
                label: 'Lastname',
                controller: _lastnameController,
                isEditing: _isEditingLastName,
                onEdit: () {
                  setState(() {
                    _isEditingLastName = !_isEditingLastName;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildEditableRow(
                label: 'Firstname',
                controller: _firstNameController,
                isEditing: _isEditingFirstName,
                onEdit: () {
                  setState(() {
                    _isEditingFirstName = !_isEditingFirstName;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildEditableRow(
                label: 'Email',
                controller: _emailController,
                isEditing: _isEditingEmail,
                onEdit: () {
                  setState(() {
                    _isEditingEmail = !_isEditingEmail;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildEditableRow(
                label: 'Password',
                controller: _passwordController,
                isEditing: _isEditingPassword,
                obscureText: true,
                hintText: '********',
                onEdit: () {
                  setState(() {
                    _isEditingPassword = !_isEditingPassword;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnyFieldEditing ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        textStyle: const TextStyle(fontSize: 18),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await deleteToken();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String newName = _lastnameController.text;
      String newFirstName = _firstNameController.text;
      String newEmail = _emailController.text;
      String newPassword = _passwordController.text;

      Map<String, dynamic> updatedUserData = {
        'Lastname': newName,
        'Firstname': newFirstName,
        'Email': newEmail,
        'Password': newPassword,
      };

      try {
        var user = await decodeToken();
        int userId = user['user_id'];

        final userService = UserService();
        await userService.updateUser(userId, updatedUserData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User profile updated successfully'),
          ),
        );
      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update user profile'),
          ),
        );
      }
    }
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
    bool obscureText = false,
    String? hintText,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: isEditing,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              enabledBorder:
                  isEditing ? const OutlineInputBorder() : InputBorder.none,
            ),
            validator: (value) {
              if (label == 'Password') {
                if (isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter a new password';
                }
              } else {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $label';
                }
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
