import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/auth/auth_service.dart';
import 'package:front/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('register_title'.tr()),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/login_page.png',
                      height: 200,
                      width: 200,
                    ),
                    if (_isLoading) const CircularProgressIndicator(),
                    if (!_isLoading) ...[
                      const SizedBox(height: 20),
                      buildTextFormField(_lastNameController, 'register_lastname'.tr(), TextInputType.text),
                      const SizedBox(height: 10),
                      buildTextFormField(_firstNameController, 'register_firstname'.tr(), TextInputType.text),
                      const SizedBox(height: 10),
                      buildTextFormField(_emailController, 'register_email'.tr(), TextInputType.emailAddress),
                      const SizedBox(height: 10),
                      buildTextFormField(_passwordController, 'register_password'.tr(), TextInputType.text, obscureText: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser(
                              _emailController.text,
                              _passwordController.text,
                              _firstNameController.text,
                              _lastNameController.text,
                            );
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                        ),
                        child: Text('register_submit'.tr(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'register_already_in_our_paper'.tr(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.amber,
                      ),
                      child: Text('register_go_login'.tr()),
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

  TextFormField buildTextFormField(
      TextEditingController controller, String label, TextInputType keyboardType, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label invalide';
        }
        return null;
      },
    );
  }

  void registerUser(String email, String password, String firstname, String lastname) async {
    setState(() {
      _isLoading = true;
    });

    var response = await register(email, password, firstname, lastname);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (response == 201) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('register_successful'.tr(), style: const TextStyle(color: Colors.green)),
            content: Text('register_user_created_successfully'.tr(), style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey[850],
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('error'.tr(), style: const TextStyle(color: Colors.red)),
            content: Text('${'register_error'.tr()} $response', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey[850],
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }
}
