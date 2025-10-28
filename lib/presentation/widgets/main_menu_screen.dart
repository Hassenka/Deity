import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/presentation/screens/favorite/favorite_recipes_screen.dart';
import 'package:diety/presentation/screens/notif/notif_list_screen.dart';
import 'package:diety/presentation/screens/search/filter_screen.dart';
import 'package:diety/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:diety/presentation/screens/home/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteRecipesScreen(),
    DietySearchScreen(),
    //const FilterScreen(),
    const NotificationScreen(),
  ];

  // For AnimatedBottomNavigationBar, we provide a list of icons.
  final List<String> _iconPaths = [
    'assets/images/menu1.svg',
    'assets/images/menu2.svg',
    'assets/images/menu3.svg',
    'assets/images/menu4.svg',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch the user's saved recipes when the main screen loads.
    Provider.of<NotificationProvider>(
      context,
      listen: false,
    ).fetchNotificationCount();
    FavoritesManager().fetchFavorites();
  }
  // Titles for each tab
  //final List<String> _titles = ["الرئيسية", "وصفاتي", "بحث", "حسابي"];

  Widget _buildNavIcon(String assetPath, Color color) {
    return SvgPicture.asset(
      assetPath,
      width: 23,
      height: 23,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      placeholderBuilder: (context) =>
          Icon(Icons.error, color: color, size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_bottomNavIndex],
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'main_menu_fab', // Unique tag for this FAB
            backgroundColor: AppColors.primary,
            // Note: Replace with your 'plus.svg' path when it's available.
            // ignore: sort_child_properties_last
            child: _buildNavIcon(
              'assets/images/settings-sliders.svg',

              AppColors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: Provider.of<NotificationProvider>(context),
                    child: const FilterScreen(),
                  ),
                ),
              );
            },
            shape: const CircleBorder(), // if you want a perfect circle
          ),
          const SizedBox(height: 4), // Space between button and text
          // const Text(
          //   "إضافة", // "Add" in Arabic
          //   style: TextStyle(color: AppColors.grey, fontSize: 12),
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _iconPaths.length,

        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.primary : AppColors.grey;
          Widget icon = _buildNavIcon(_iconPaths[index], color);

          // Check if it's the notification icon (index 3) and there are notifications
          if (index == 3 && _notificationCount > 0) {
            icon = Stack(
              clipBehavior: Clip
                  .none, // Allow the badge to be drawn outside the icon's bounds
              alignment: Alignment.center,
              children: [
                _buildNavIcon(_iconPaths[index], color),
                Positioned(
                  top: -4,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _notificationCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              // const SizedBox(height: 4),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Text(
              //     _titles[index],
              //     maxLines: 1,
              //     style: TextStyle(
              //       color: color,
              //       fontFamily: 'Tajawal',
              //       fontSize: 15,
              //     ),
              //   ),
              // ),
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          if (index == 3) {
            // If notification tab is tapped
            Provider.of<NotificationProvider>(
              context,
              listen: false,
            ).fetchNotificationCount();
          }
          setState(() => _bottomNavIndex = index);
        },
        backgroundColor: Colors.white,
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ),
    );
  }

  int get _notificationCount {
    return Provider.of<NotificationProvider>(context).unreadCount;
  }
}
