import 'package:flutter/material.dart';

import 'home_view.dart';
import 'spent_view.dart';
import 'members_view.dart';
import 'settings_view.dart';
import '../app_colors.dart';
import '../widgets/svg.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeView(),
    SpentView(),
    MembersView(),
    SettingsView(),
  ];

  /// ✅ ICON + UNDERLINE (NO COLOR ON IMAGE)
  Widget navItem(String asset, int index) {
    final bool isSelected = _selectedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          asset,
          height: 24,
          width: 24,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),

        // ✅ UNDERLINE INDICATOR
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 3,
          width: isSelected ? 24 : 0,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.secondaryColor, // text only
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 8,

        items: [
          BottomNavigationBarItem(
            icon: navItem(SvgManager.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: navItem(SvgManager.wallet, 1),
            label: 'Spent',
          ),
          BottomNavigationBarItem(
            icon: navItem(SvgManager.members, 2),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: navItem(SvgManager.members, 3),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
