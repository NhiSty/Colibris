import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/auth/auth_service.dart';
import 'package:front/main.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/auth/register.dart';
import 'package:front/home_screen.dart';
import 'package:front/reset-password/reset_password.dart';
import 'package:front/utils/firebase.dart';
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                            TextStyle(color: Color(0xFFD00000), fontSize: 15),
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
                            TextStyle(color: Color(0xFFD00000), fontSize: 15),
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
                        backgroundColor: Colors.blueGrey[800],
                      ),
                      child: Text(
                        'login_login'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleGoogleSignIn,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text(
                        'Login with Google',
                        style: TextStyle(fontSize: 16),
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

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        // print("user $user");
        final res = await signWithGoogle(
          user.email!,
          user.displayName ?? '',
          idToken ?? '',
          user.providerData[0].providerId,
        );

        if (res == 200) {
          final token = await firebaseClient.getFcmToken();
          await addFcmToken(token as String);

          if (!mounted) return;
          context.push(HomeScreen.routeName);
        } else {
          print('Échec de la connexion avec Google');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  loginClick() async {
    if (_formKey.currentState!.validate()) {
      var res =
          await login(_emailController.text.trim(), _passwordController.text);
      if (!mounted) return;
      if (res == 200) {
        final token = await firebaseClient.getFcmToken();
        await addFcmToken(token as String);
        await login(_emailController.text.trim(), _passwordController.text);
        if (await isConnected()) {
          context.push(HomeScreen.routeName);
        }

        if (widget.data["intendedRoute"] != null &&
            widget.data["intendedRoute"]!.isNotEmpty) {
          context.push(widget.data["intendedRoute"]!, extra: {
            widget.data["paramName"]: widget.data["value"],
            "fromNotification": widget.data["fromNotification"]
          });
          return;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text('error'.tr(), style: const TextStyle(color: Color(0xFFD00000))),
              content: Text('error_email_or_password'.tr(),
                  style: const TextStyle(color: Colors.white)),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK', style: TextStyle(color: Color(0xFFD00000))),
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
