import 'dart:async';
import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/presentation/screens/login/login_screen.dart';
import 'package:diety/presentation/widgets/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Animation will run for 3 seconds
    );

    // Fade animation from invisible to fully visible
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Scale animation to grow the text with a bounce effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to HomeScreen after a total of 6 seconds
    Timer(const Duration(seconds: 6), _checkAuthStatusAndNavigate);
  }

  void _checkAuthStatusAndNavigate() async {
    // Ensure the widget is still mounted before performing async operations.
    if (!mounted) return;

    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    // If the widget is still mounted after the async call, proceed with navigation.
    if (mounted) {
      final Widget destination;
      if (token != null && token.isNotEmpty) {
        destination = MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider.value(
              value: FavoritesManager(),
            ), // Use .value for singleton
          ],
          child: const MainScreen(), // MainScreen will now have access to both
        );
      } else {
        destination = const LoginScreen();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InternetConnectionWrapper(child: destination),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: You mentioned a blue background. The current palette has green (primary)
    // and yellow (accent). I've used the primary green to match the website's branding.
    // We can easily add a blue color to `app_colors.dart` if you prefer!
    return Scaffold(
      // backgroundColor: AppColors.primary,
      backgroundColor: AppColors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              "Diety",
              //AppStrings.appName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                color: AppColors.primary,
                // AppColors.white,
                //fontWeight: FontWeight.bold,
                fontSize: 60.sp, // Using .sp for responsive font size
              ),
            ),
          ),
        ),
      ),
    );
  }
}
