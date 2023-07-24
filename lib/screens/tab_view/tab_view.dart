import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({super.key, required this.child});

  final Widget child;

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final PageController pageController = PageController();
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
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
