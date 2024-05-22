import 'package:flutter/material.dart';
import 'package:front/website/pages/auth/login_page.dart';
import 'package:front/website/pages/auth/register_page.dart';
import 'package:front/website/pages/backoffice/user_handle_page.dart';
import 'package:front/website/pages/home_page.dart';

void main() {
  runApp(const MyWebsite());
}

class MyWebsite extends StatelessWidget {
  const MyWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BackOffice administration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/backoffice/user': (context) => const UserHandlePage(),
        });
  }
}
