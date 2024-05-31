import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'home_screen.dart';
import 'invitation/invitation_list_page.dart';
import 'colocation/create_colocation.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvitationBloc>(
          create: (context) => InvitationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/create_colocation': (context) => const CreateColocationPage(),
          '/invitations': (context) => BlocProvider.value(
                value: BlocProvider.of<InvitationBloc>(context),
                child: const InvitationListPage(invitations: []),
              ),
        },
      ),
    );
  }
}
