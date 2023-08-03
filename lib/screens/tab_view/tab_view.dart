import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabView extends StatefulWidget {
  const TabView({super.key, required this.child});

  final Widget child;

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndexNotifier,
        builder: (context, value, child) {
          return BottomNavigationBar(
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: value,
            onTap: (index) {
              currentIndexNotifier.value = index;
              context.go(pages[index]);
            },
            items: const [
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.home_outlined),
              //   label: 'Home',
              //   activeIcon: Icon(Icons.home_rounded),
              // ),
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
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.person_outline_rounded),
              //   label: 'Profile',
              //   activeIcon: Icon(Icons.person_rounded),
              // ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    currentIndexNotifier.dispose();

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

List<String> pages = ['/explore', '/trips'];
