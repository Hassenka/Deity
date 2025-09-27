import 'package:diety/core/constants/app_strings.dart';
import 'package:diety/core/theme/app_theme.dart';
import 'package:diety/presentation/screens/splash/splash_screen.dart'
    show SplashScreen;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';

class DietyApp extends StatelessWidget {
  const DietyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit is used to make the UI responsive.
    // Wrap your MaterialApp with it.
    return ScreenUtilInit(
      designSize: const Size(
        375,
        812,
      ), // Design size from your UI designer (e.g., iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // --- Device Preview Configuration ---
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          // --- Localization Configuration ---
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', ''), // Arabic
            // Locale('en', ''), // English (if you add it later)
          ],

          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,

          home: child,
        );
      },
      // The first screen of your app.
      child: const SplashScreen(),
    );
  }
}
