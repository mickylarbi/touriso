import 'package:go_router/go_router.dart';
import 'package:touriso/screens/auth/auth_shell.dart';
import 'package:touriso/screens/auth/login_screen.dart';
import 'package:touriso/screens/auth/register_screen.dart';
import 'package:touriso/screens/tab_view/chat/chat_page.dart';
import 'package:touriso/screens/tab_view/home/home_page.dart';
import 'package:touriso/screens/tab_view/profile/profile_page.dart';
import 'package:touriso/screens/tab_view/search/explore_page.dart';
import 'package:touriso/screens/tab_view/search/search_screen.dart';
import 'package:touriso/screens/tab_view/tab_view.dart';
import 'package:touriso/screens/tab_view/bookings/booking_details_page.dart';
import 'package:touriso/screens/tab_view/bookings/booking_history_page.dart';
import 'package:touriso/screens/tab_view/bookings/bookings_list_page.dart';
import 'package:touriso/utils/firebase_helper.dart';

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
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) => const SearchScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              builder: (context, state) => const BookingsListPage(),
              routes: [
                GoRoute(
                  path: 'booking_details/:bookingId',
                  builder: (context, state) => BookingDetailsPage(
                    bookingId: state.pathParameters['bookingId']!,
                  ),
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => const BookingHistory(),
                  routes: [
                    GoRoute(
                      path: 'booking_details/:bookingId',
                      builder: (context, state) => BookingDetailsPage(
                        bookingId: state.pathParameters['bookingId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatPage(),
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
  initialLocation: auth.currentUser == null ? '/login' : '/explore',
);
