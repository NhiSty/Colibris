import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_flags_toggly/feature_flags_toggly.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/auth/login.dart';
import 'package:front/auth/register.dart';
import 'package:front/chat/screens/conversation_screen.dart';
import 'package:front/colocation/bloc/colocation_bloc.dart';
import 'package:front/colocation/colocation_members.dart';
import 'package:front/colocation/colocation_members_list.dart';
import 'package:front/colocation/colocation_parameters.dart';
import 'package:front/colocation/colocation_tasklist_screen.dart';
import 'package:front/colocation/colocation_update.dart';
import 'package:front/colocation/create_colocation.dart';
import 'package:front/featureFlag/featureFlag.dart';
import 'package:front/featureFlag/feature_flag_service.dart';
import 'package:front/featureFlag/maintenance.dart';
import 'package:front/home_screen.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'package:front/invitation/invitation_accept_page.dart';
import 'package:front/invitation/invitation_create_page.dart';
import 'package:front/invitation/invitation_list_page.dart';
import 'package:front/profile/profile_screen.dart';
import 'package:front/reset-password/reset_password.dart';
import 'package:front/reset-password/reset_password_form.dart';
import 'package:front/shared.widget/bottom_navigation_bar.dart';
import 'package:front/task/add_new_task_screen.dart';
import 'package:front/task/bloc/task_bloc.dart';
import 'package:front/task/camera_screen.dart';
import 'package:front/task/task_detail.dart';
import 'package:front/task/update_task_screen.dart';
import 'package:front/utils/firebase.dart';
import 'package:front/website/share/secure_storage.dart';
import 'firebase_options.dart';
import 'package:front/vote/bloc/vote_bloc.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

final StreamController<List<FeatureFlag>> _featureFlagsController =
    StreamController<List<FeatureFlag>>.broadcast();

var intendedRoute = '/';

final previousFlags = <FeatureFlag>[];

Future<void> initializeFeatureFlags(List<FeatureFlag> flags) async {
  await Toggly.init(
    flagDefaults: {
      for (var flag in flags) flag.name: flag.value,
    },
  );
}

bool isFeatureEnabled(String featureName, List<FeatureFlag> flags) {
  var flag = flags.firstWhere((flag) => flag.name == featureName,
      orElse: () => FeatureFlag(id: -1, name: featureName, value: false));
  return flag.value;
}

void onMessage(RemoteMessage message) {
  print('Message en premier plan reçu: ${message.notification?.title}');
}

void onMessageOpenedApp(RemoteMessage message) {
  print('Message cliqué!: ${message.notification?.title}');
  String? colocationIdStr = message.data['colocationID'];
  int colocationId = int.tryParse(colocationIdStr!) ?? 0;

  if (colocationId != 0) {
    String notificationType = message.data['type'] ?? 'default';

    switch (notificationType) {
      case 'chat':
        navigatorKey.currentContext?.go(LoginScreen.routeName, extra: {
          'value': colocationId,
          'intendedRoute': ConversationScreen.routeName,
          'paramName': 'chatId',
          'fromNotification': true,
        });
        break;
      case 'invitation':
        String? invitationIdStr = message.data['invitationID'];
        int invitationId = int.tryParse(invitationIdStr!) ?? 0;

        navigatorKey.currentContext?.go(LoginScreen.routeName, extra: {
          'colocationId': colocationId,
          'invitationId': invitationId,
          'intendedRoute': InvitationAcceptPage.routeName,
          'fromNotification': true,
        });
        break;
      default:
        print('Type de notification inconnu');
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseClient firebaseClient = FirebaseClient();
  await firebaseClient.requestPermission();
  firebaseClient.initializeListeners(onMessage, onMessageOpenedApp);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  var initialFlags = await fetchFeatureFlags();
  await initializeFeatureFlags(initialFlags);
  previousFlags.addAll(initialFlags);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: StreamBuilder<List<FeatureFlag>>(
        stream: _featureFlagsController.stream,
        initialData: initialFlags,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyApp(
              featureFlag: snapshot.data!,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    ),
  );

  Stream<int> periodicStream =
      Stream.periodic(const Duration(seconds: 15), (count) => count);

  periodicStream.listen((event) async {
    var flags = await fetchFeatureFlags();

    for (var flag in flags) {
      var previousFlag = previousFlags.firstWhere(
        (previousFlag) => previousFlag.name == flag.name,
        orElse: () =>
            FeatureFlag(id: flag.id, name: flag.name, value: !flag.value),
      );
      if (flag.value != previousFlag.value) {
        await initializeFeatureFlags(flags);
        previousFlags.clear();
        previousFlags.addAll(flags);
        _featureFlagsController.add(flags);
        break;
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.featureFlag});

  final List<FeatureFlag> featureFlag;

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      navigatorKey: navigatorKey,
      redirect: (BuildContext context, GoRouterState state) async {
        final isAuthenticated = await isConnected();
        final isMaintenanceMode =  await isFeatureEnabled('maintenance', featureFlag);

        if(isMaintenanceMode){
          return MaintenanceScreen.routeName;
        }
        if (!isAuthenticated) {
          if (state.fullPath == RegisterScreen.routeName) {
            return RegisterScreen.routeName;
          } else if (state.fullPath == ResetPasswordScreen.routeName) {
            return ResetPasswordScreen.routeName;
          } else if (state.fullPath == ResetPasswordFormScreen.routeName) {
            return ResetPasswordFormScreen.routeName;
          }
          return LoginScreen.routeName;
        }
      },
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) =>
                isFeatureEnabled('maintenance', featureFlag)
                    ? const MaintenanceScreen()
                    : PopScope(
                        canPop: false,
                        child: LoginScreen(
                          data: state.extra,
                        ))),
        GoRoute(
          path: MaintenanceScreen.routeName,
          builder: (context, state) => const MaintenanceScreen(),
        ),
        GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => PopScope(
              canPop: false,
              child: LoginScreen(
                data: state.extra,
              )),
        ),
        GoRoute(
          path: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: HomeScreen.routeName,
          builder: (context, state) => const PopScope(
            canPop: false,
            child: Scaffold(
              body: HomeScreen(),
              bottomNavigationBar: BottomNavigationBarWidget(null),
            ),
          ),
        ),
        GoRoute(
          path: CreateColocationPage.routeName,
          builder: (context, state) => const CreateColocationPage(),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          builder: (context, state) => const Scaffold(
            body: ProfileScreen(),
            bottomNavigationBar: BottomNavigationBarWidget(null),
          ),
        ),
        GoRoute(
          path: ResetPasswordScreen.routeName,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: ResetPasswordFormScreen.routeName,
          builder: (context, state) {
            final Map<String, String> arguments =
                state.extra as Map<String, String>;
            return ResetPasswordFormScreen(arguments: arguments);
          },
        ),
        GoRoute(
          path: InvitationListPage.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<InvitationBloc>(context),
            child: InvitationListPage(
              invitations: (state.extra as Map)['invitations'],
            ),
          ),
        ),
        GoRoute(
          path: InvitationCreatePage.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<InvitationBloc>(context),
            child: InvitationCreatePage(
              colocationId: (state.extra as Map)['colocationId'],
            ),
          ),
        ),
        GoRoute(
          path: ColocationTasklistScreen.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<ColocationBloc>(context),
            child: ColocationTasklistScreen(
              colocation: (state.extra as Map)['colocation'],
            ),
          ),
        ),
        GoRoute(
          path: InvitationAcceptPage.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<InvitationBloc>(context),
            child: InvitationAcceptPage(
              invitationId: (state.extra as Map)['invitationId'],
              colocationId: (state.extra as Map)['colocationId'],
            ),
          ),
        ),
        GoRoute(
          path: ColocationSettingsPage.routeName,
          builder: (context, state) => ColocationSettingsPage(
            colocationId: (state.extra as Map)['colocationId'],
          ),
        ),
        GoRoute(
          path: ColocationMembers.routeName,
          builder: (context, state) => ColocationMembers(
            users: (state.extra as Map)['users'],
          ),
        ),
        GoRoute(
          path: ColocationMembersList.routeName,
          builder: (context, state) => ColocationMembersList(
            users: (state.extra as Map)['users'],
          ),
        ),
        GoRoute(
          path: ColocationUpdatePage.routeName,
          builder: (context, state) => ColocationUpdatePage(
            colocationId: (state.extra as Map)['colocationId'],
          ),
        ),
        GoRoute(
          path: TaskDetailPage.routeName,
          builder: (context, state) => TaskDetailPage(
            task: (state.extra as Map)['task'],
          ),
        ),
        GoRoute(
          path: ConversationScreen.routeName,
          builder: (context, state) => ConversationScreen(
            conversationId: (state.extra as Map)['chatId'],
            fromNotification: (state.extra as Map)['fromNotification'] ?? false,
          ),
        ),
        GoRoute(
          path: AddNewTaskScreen.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<TaskBloc>(context),
            child: AddNewTaskScreen(
              colocation: (state.extra as Map)['colocation'],
            ),
          ),
        ),
        GoRoute(
          path: UpdateTaskScreen.routeName,
          builder: (context, state) => BlocProvider.value(
            value: BlocProvider.of<TaskBloc>(context),
            child: UpdateTaskScreen(
              colocation: (state.extra as Map)['colocation'],
              task: (state.extra as Map)['task'],
            ),
          ),
        ),
        GoRoute(
          path: CameraScreen.routeName,
          builder: (context, state) =>
              CameraScreen(cameras: (state.extra as Map)['camera']),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<InvitationBloc>(
          create: (context) => InvitationBloc(),
        ),
        BlocProvider<ColocationBloc>(
          create: (context) => ColocationBloc(),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(),
        ),
        BlocProvider<VoteBloc>(
          create: (context) => VoteBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        title: 'Colobri',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.green,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blueGrey,
            secondary: Colors.blueAccent,
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.black,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF66CDAA), Color(0xFF008B8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
