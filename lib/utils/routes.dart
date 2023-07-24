import 'package:go_router/go_router.dart';
import 'package:touriso/screens/auth/auth_screen.dart';
import 'package:touriso/screens/tab_view/home/home_page.dart';
import 'package:touriso/screens/tab_view/tab_view.dart';

GoRouter goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthScreen(
        authType: state.queryParameters['authType'] == 'login'
            ? AuthType.login
            : AuthType.signUp,
      ),
    ),
    ShellRoute(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
      builder: (context, state, child) => TabView(
        child: child,
      ),
    ),

  ],

  
);
