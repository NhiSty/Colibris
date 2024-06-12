import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/auth/login_page.dart';
import 'package:front/website/pages/auth/register_page.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user_handle_page.dart';
import 'package:front/website/pages/home_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyWebsite());
}

class MyWebsite extends StatelessWidget {
  const MyWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(userService: UserService())..add(LoadUsers()),
        ),
      ],
      child: MaterialApp(
        title: 'BackOffice administration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/backoffice/user': (context) => const UserHandlePage(),
        },
      ),
    );
  }
}
