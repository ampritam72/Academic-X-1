import 'package:flutter/material.dart';
import 'package:academic_x/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:academic_x/widgets/shared_widgets.dart';
import 'package:academic_x/screens/dashboard_screen.dart';
import 'package:academic_x/screens/slide_analyzer_screen.dart';
import 'package:academic_x/screens/profile_screen.dart';

import 'package:academic_x/screens/club_zone_screen.dart';
import 'package:academic_x/screens/chat_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<Widget> _pages = const [
    DashboardScreen(),
    SlideAnalyzerScreen(),
    ClubZoneScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentIndex = navProvider.currentIndex;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(currentIndex),
          child: _pages[currentIndex],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => navProvider.setIndex(i),
      ),
    );
  }
}
