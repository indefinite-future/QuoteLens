import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:fypv2/themes/themes.dart';
import 'library_screen.dart';
import 'quote_screen.dart';
import 'user_screen.dart';

class LibraryMain extends StatefulWidget {
  const LibraryMain({super.key});

  @override
  State<LibraryMain> createState() => _LibraryMainState();
}

class _LibraryMainState extends State<LibraryMain> {
  int _currentIndex = 0;

  final List<Widget> _tabScreens = [
    const HomeScreen(),
    const QuoteScreen(),
    const UserScreen(),
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
                height: 110, //min 89
                child: BottomNavigationBar(
                  //bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: MyAppsTheme.currentTheme
                      .scaffoldBackgroundColor, //const Color(0xFF212121),
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.cyan,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.book, color: Colors.white),
                      activeIcon:
                          Icon(FeatherIcons.bookOpen, color: Colors.cyan),
                      label: 'Library',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.bookmark, color: Colors.white),
                      activeIcon:
                          Icon(Icons.bookmark_rounded, color: Colors.cyan),
                      label: 'Quotes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded,
                          color: Colors.white),
                      activeIcon:
                          Icon(Icons.person_rounded, color: Colors.cyan),
                      label: 'Profile',
                    ),
                  ],
                ))));
  }
}
