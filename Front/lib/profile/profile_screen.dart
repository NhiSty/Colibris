import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
import 'package:front/user/user_service.dart';
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
      final userData = await getUserById(userId);
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
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('profile'.tr()),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'user_settings'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildEditableRow(
                      label: 'lastname'.tr(),
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
                      label: 'firstname'.tr(),
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
                      label: 'email'.tr(),
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
                      label: 'password'.tr(),
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
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 18),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('submit'.tr()),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🇺🇸', style: TextStyle(fontSize: 32)),
                        Switch(
                          value: context.locale == const Locale('fr'),
                          onChanged: (value) {
                            setState(() {
                              context.setLocale(
                                  value ? const Locale('fr') : const Locale('en'));
                            });
                          },
                        ),
                        const Text('🇫🇷', style: TextStyle(fontSize: 32)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

        await updateUser(userId, updatedUserData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarFeedback(
            'update_success'.tr(),
            Colors.green,
          ),
        );

      } catch (e) {
        print('Error updating user data: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarFeedback(
            'update_failure'.tr(),
            Colors.red,
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
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: isEditing,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              labelStyle: const TextStyle(color: Colors.white),
              border: const OutlineInputBorder(),
              enabledBorder:
              isEditing ? const OutlineInputBorder() : InputBorder.none,
              hintStyle: const TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (label == 'password'.tr()) {
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
          color: Colors.white,
          onPressed: onEdit,
        ),
      ],
    );
  }
}
