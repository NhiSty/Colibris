import 'package:flutter/material.dart';
import 'package:front/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Colibri',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'assets/images/login_page.png',
                  height: 300,
                  width: 300,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mot de passe invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginClick,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Connexion'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pas encore connu de nos service?',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('Inscris-toi !'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset-password');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('Mot de passe oublié !'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  loginClick() async {
    if (_formKey.currentState!.validate()) {
      var res = await login(_emailController.text, _passwordController.text);
      if (!mounted) return;
      if (res == 200) {
        Navigator.pushNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: const Text('Email ou mot de passe incorrect'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
