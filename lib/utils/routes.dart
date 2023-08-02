import 'package:go_router/go_router.dart';
import 'package:touriso/screens/auth/auth_shell.dart';
import 'package:touriso/screens/auth/login_screen.dart';
import 'package:touriso/screens/auth/register_screen.dart';
import 'package:touriso/screens/tab_view/home/home_page.dart';
import 'package:touriso/screens/tab_view/more/more_page.dart';
import 'package:touriso/screens/tab_view/search/explore_page.dart';
import 'package:touriso/screens/tab_view/search/search_screen.dart';
import 'package:touriso/screens/tab_view/tab_view.dart';
import 'package:touriso/screens/tab_view/trips/trips_page.dart';

GoRouter goRouter = GoRouter(
  routes: [
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
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePage(),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),

          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              builder: (context, state) => const TripsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) =>
          TabView(child: navigationShell),
    ),
  ],
  initialLocation: '/login',
);
