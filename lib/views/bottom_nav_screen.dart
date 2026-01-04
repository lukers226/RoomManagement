import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_view.dart';
import 'spent_view.dart';
import 'members_view.dart';
import 'settings_view.dart';
import '../app_colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    SpentView(),
    MembersView(),
    SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive helpers
    double w(double v) => size.width * v;
    double h(double v) => size.height * v;
    double sp(double v) => size.width * v;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w(0.04),
              vertical: h(0.01),
            ),
            child: GNav(
              rippleColor: AppColors.secondaryColor.withAlpha(1),
              hoverColor: AppColors.secondaryColor.withAlpha(1),
              gap: w(0.02),
              activeColor: AppColors.white,
              iconSize: sp(0.06),
              padding: EdgeInsets.symmetric(
                horizontal: w(0.05),
                vertical: h(0.015),
              ),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.secondaryColor,
              color: Colors.grey,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.money_off,
                  text: 'Spent',
                ),
                GButton(
                  icon: Icons.group,
                  text: 'Members',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
