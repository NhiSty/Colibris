import 'package:flutter/material.dart';
import 'package:front/website/pages/home_page.dart';
import 'package:front/website/pages/login_page.dart';
import 'package:front/website/pages/register_page.dart';

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
        });
  }
}
