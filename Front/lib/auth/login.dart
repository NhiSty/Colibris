import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/auth/auth_service.dart';
import 'package:front/main.dart';
import 'package:front/auth/register.dart';
import 'package:front/home_screen.dart';
import 'package:front/reset-password/reset_password.dart';
import 'package:front/utils/firebase.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.data});
  static const routeName = "/login";
  var data;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseClient firebaseClient = FirebaseClient();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/login_page.png',
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'login_email'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email_invalid'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'login_password'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'login_password_error'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: loginClick,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: Text(
                        'login_login'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'login_unknown_for_our_service'.tr(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(RegisterScreen.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.yellow,
                      ),
                      child: Text('login_register'.tr()),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(ResetPasswordScreen.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.yellow,
                      ),
                      child: Text('login_forget_password'.tr()),
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

  loginClick() async {
    if (_formKey.currentState!.validate()) {
      var res =
          await login(_emailController.text.trim(), _passwordController.text);
      if (!mounted) return;
      if (res == 200) {
        final token = await firebaseClient.getFcmToken();
        await addFcmToken(token as String);

        if (await isConnected()) {
          context.push(HomeScreen.routeName);
        }

        if (widget.data["intendedRoute"] != null &&
            widget.data["intendedRoute"]!.isNotEmpty) {
          context.push(widget.data["intendedRoute"]!,
              extra: {widget.data["paramName"]: widget.data["value"]});
          return;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text('error'.tr(), style: const TextStyle(color: Colors.red)),
              content: Text('error_email_or_password'.tr(),
                  style: const TextStyle(color: Colors.white)),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
