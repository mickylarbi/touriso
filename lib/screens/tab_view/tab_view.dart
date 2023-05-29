import 'package:flutter/material.dart';
import 'package:touriso/screens/tab_view/booking/booking_screen.dart';
import 'package:touriso/screens/tab_view/chat/chat_screen.dart';
import 'package:touriso/screens/tab_view/history/history_screen.dart';
import 'package:touriso/screens/tab_view/more/more_screen.dart';
import 'package:touriso/screens/tab_view/pending/pending_screen.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final PageController pageController = PageController();
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            PendingScreen(),
            BookingScreen(),
            HistoryScreen(),
            ChatScreen(),
            MoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndexNotifier,
        builder: (context, value, child) {
          return BottomNavigationBar(
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: value,
            onTap: (index) {
              if (index != currentIndexNotifier.value) {
                currentIndexNotifier.value = index;
                pageController.jumpToPage(currentIndexNotifier.value);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                activeIcon: Icon(Icons.home_rounded),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                label: 'Explore',
                activeIcon: Icon(Icons.search_rounded),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tour_rounded),
                label: 'Tours',
                activeIcon: Icon(Icons.tour_rounded),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                label: 'Chat',
                activeIcon: Icon(Icons.chat_bubble_rounded),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'More',
                activeIcon: Icon(Icons.settings),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  ///places
  ///packages (transport, accommodation, feeding)
  ///packages can have multiple locations/places
  ///region
  ///
  ///
  ///models
  ///tourist site
  /// - name
  /// - city/town/village
  /// - region
  /// - description
  ///
  ///package
  /// - title
  /// - tourist site
  /// - transport
  /// - accommodation
  /// - feeding
  /// - price
  /// - duration
}
