import 'package:go_router/go_router.dart';
import 'package:touriso/screens/auth/auth_shell.dart';
import 'package:touriso/screens/auth/login_screen.dart';
import 'package:touriso/screens/auth/register_screen.dart';
import 'package:touriso/screens/tab_view/home/home_page.dart';
import 'package:touriso/screens/tab_view/tab_view.dart';

GoRouter goRouter = GoRouter(routes: [
  ShellRoute(
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    builder: (context, state, child) => AuthShell(child: child),
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
], initialLocation: '/login');
