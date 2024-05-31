import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/auth/login.dart';
import 'package:front/auth/register.dart';
import 'package:front/colocation/bloc/colocation_bloc.dart';
import 'package:front/colocation/colocation_tasklist_screen.dart';
import 'package:front/colocation/create_colocation.dart';
import 'package:front/home_screen.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'package:front/invitation/invitation_list_page.dart';
import 'package:front/services/user_service.dart';
import 'package:front/shared.widget/bottom_navigation_bar.dart';

var userData;
void main() async {
  await dotenv.load(fileName: ".env");
  userData = await decodeToken();
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
        BlocProvider<ColocationBloc>(
          create: (context) => ColocationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Colobris',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const Scaffold(
                body: HomeScreen(),
                bottomNavigationBar: BottomNavigationBarWidget(),
              ),
          '/create_colocation': (context) => const CreateColocationPage(),
        },
        onGenerateRoute: (settings) {
          final routes = settings.arguments as Map;
          switch (settings.name) {
            case ColocationTasklistScreen.routeName:
              return MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<ColocationBloc>(context),
                        child: ColocationTasklistScreen(
                            colocation: routes['colocation'],
                            userId: userData['user_id']),
                      ),
                  settings: settings);
            case '/invitations':
              return MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<InvitationBloc>(context),
                        child: InvitationListPage(
                            invitations: routes['invitations']),
                      ),
                  settings: settings);
          }
          return null;
        },
      ),
    );
  }
}
