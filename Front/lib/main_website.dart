import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:front/services/colocMember_service.dart';
import 'package:front/services/colocation_service.dart';
import 'package:front/services/log_service.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/auth/login_page.dart';
import 'package:front/website/pages/backoffice/colocMember_handle_page.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocation_handle_page.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:front/website/pages/backoffice/feature_toggle_page.dart';
import 'package:front/website/pages/backoffice/log_handle_page.dart';
import 'package:front/website/pages/backoffice/logs/bloc/log_bloc.dart';
import 'package:front/website/pages/backoffice/messages_handle_page.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user_handle_page.dart';
import 'package:front/website/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      redirect: (BuildContext context, GoRouterState state) async {
        final isAuthenticated = await isConnected();
        if (!isAuthenticated) {
          return LoginPage.routeName;
        }
      },
      routes: [
        GoRoute(
          path: LoginPage.routeName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: HomePage.routeName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: UserHandlePage.routeName,
          builder: (context, state) => const UserHandlePage(),
        ),
        GoRoute(
          path: LogPage.routeName,
          builder: (context, state) => const LogPage(),
        ),
        GoRoute(
          path: ColocationHandlePage.routeName,
          builder: (context, state) => const ColocationHandlePage(),
        ),
        GoRoute(
          path: FeatureTogglePage.routeName,
          builder: (context, state) => const FeatureTogglePage(),
        ),
        GoRoute(
          path: ColocMemberHandlePage.routeName,
          builder: (context, state) => const ColocMemberHandlePage(),
        ),
        GoRoute(
          path: MessagesHandlePage.routeName,
          builder: (context, state) {
            final colocationId = (state.extra as Map)['id'];
            return MessagesHandlePage(
              colocationId: colocationId,
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(userService: UserService())..add(LoadUsers()),
        ),
        BlocProvider<LogBloc>(
          create: (context) =>
              LogBloc(logService: LogService())..add(FetchLogs()),
        ),
        BlocProvider<ColocationBloc>(
          create: (context) =>
              ColocationBloc(colocationService: ColocationService())
                ..add(LoadColocations()),
        ),
        BlocProvider<ColocMemberBloc>(
          create: (context) =>
              ColocMemberBloc(colocMemberService: ColocMemberService())
                ..add(LoadColocMembers()),
        ),
      ],
      child: MaterialApp.router(
        title: 'BackOffice administration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
