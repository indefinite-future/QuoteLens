import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'library_page.dart';
import 'quote_page.dart';
import 'user_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _tabScreens = [
    LibraryPage(),
    const QuotePage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabScreens[_currentIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              0.11, // 10% of screen height,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context)
                .scaffoldBackgroundColor, //const Color(0xFF212121),
            unselectedItemColor: Theme.of(context).primaryColor,
            selectedItemColor: Colors.cyan,
            showUnselectedLabels: true,
            unselectedLabelStyle:
                TextStyle(color: Theme.of(context).primaryColor),
            selectedLabelStyle: const TextStyle(color: Colors.cyan),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.book,
                    color: Theme.of(context).primaryColor),
                activeIcon:
                    const Icon(FeatherIcons.bookOpen, color: Colors.cyan),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.bookmark,
                    color: Theme.of(context).primaryColor),
                activeIcon:
                    const Icon(Icons.bookmark_rounded, color: Colors.cyan),
                label: 'Quotes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded,
                    color: Theme.of(context).primaryColor),
                activeIcon:
                    const Icon(Icons.person_rounded, color: Colors.cyan),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
