import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../home/dashboard_tab.dart';
import '../goals/goals_screen.dart';
import '../sleep/sleep_screen.dart';
import '../store/store_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardTab(onNavigate: (i) => setState(() => _currentIndex = i)),
      const GoalsScreen(),
      const SleepScreen(),
      const StoreScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BungweBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
