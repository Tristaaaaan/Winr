import 'package:flutter/material.dart';
import 'package:winr/common/components/navbar/custom_navbar.dart';
import 'package:winr/feature/history/presentation/history_screen.dart';
import 'package:winr/feature/home/presentation/screen/homescreen.dart';
import 'package:winr/feature/settings/presentation/settings_screen.dart';

class NavigationGate extends StatefulWidget {
  const NavigationGate({super.key});

  @override
  State<NavigationGate> createState() => _NavigationGateState();
}

class _NavigationGateState extends State<NavigationGate> {
  int _selectedIndex = 0;
  final bool _isHolding = false;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _screens => [
    const HomeScreen(),
    HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // main screen
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _screens[_selectedIndex],
          ),

          // bottom nav bar
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: _isHolding ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: _isHolding,
                child: CustomBottomNavBar(
                  currentIndex: _selectedIndex,
                  onTap: _onTabSelected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
