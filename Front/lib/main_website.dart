import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/services/colocation_service.dart';
import 'package:front/services/log_service.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/auth/login_page.dart';
import 'package:front/website/pages/backoffice/colocation_handle_page.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:front/website/pages/backoffice/conversation_handle_page.dart';
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
      ],
      child: MaterialApp(
        title: 'BackOffice administration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          print('Generating route for: ${settings.name}');
          final Uri uri = Uri.parse(settings.name ?? '');
          if (uri.pathSegments.length == 4 &&
              uri.pathSegments[0] == 'backoffice' &&
              uri.pathSegments[1] == 'colocations' &&
              uri.pathSegments[3] == 'messages') {
            final colocationId = uri.pathSegments[2];
            return MaterialPageRoute(
              builder: (context) => MessagesHandlePage(colocationId: int.parse(colocationId)),
            );
          }
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (context) => const LoginPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => const HomePage());
            case '/backoffice/user':
              return MaterialPageRoute(builder: (context) => const UserHandlePage());
            case '/backoffice/logs':
              return MaterialPageRoute(builder: (context) => const LogPage());
            case '/backoffice/colocations':
              return MaterialPageRoute(builder: (context) => const ColocationHandlePage());
            case '/backoffice/messages':
              return MaterialPageRoute(builder: (context) => const ConversationHandlePage());
            case '/feature-flipping':
              return MaterialPageRoute(builder: (context) => const FeatureTogglePage());
            default:
              return MaterialPageRoute(builder: (context) => const HomePage());
          }
        },
      ),
    );
  }
}
