import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Colibri',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Image.asset(
                      'assets/images/login_page.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    child: TextFormField(
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
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 250,
                    child: TextFormField(
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');

                      // @TODO à rétablir quand le back sera prêt
                      /*
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        print("here");
                        /*
                        loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                        */
                      } else {
                        print("form invalide");
                      }

                       */
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Connexion'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pas encore connu de nos services?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Inscris-toi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
