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
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingFirstName = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  bool get _isAnyFieldEditing => [
        _isEditingName,
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
      String? token = await getToken();
      if (token != null) {
        int userId = 1; // Replace this with the actual user ID
        final userService = UserService();
        final userData = await userService.getUserById(userId);
        setState(() {
          _nameController.text = userData['lastname'] ?? '';
          _firstNameController.text = userData['firstname'] ?? '';
          _emailController.text = userData['email'] ?? '';
        });
      }
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
                label: 'Name',
                controller: _nameController,
                isEditing: _isEditingName,
                onEdit: () {
                  setState(() {
                    _isEditingName = !_isEditingName;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildEditableRow(
                label: 'First Name',
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
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform submit action
      print('Form submitted');
      String? token = await getToken();
      print('token ====$token');
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
              border: OutlineInputBorder(),
              enabledBorder:
                  isEditing ? OutlineInputBorder() : InputBorder.none,
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
