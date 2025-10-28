import 'package:diety/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF1A1A2E),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icone WiFi avec animation
                      _buildAnimatedWiFiIcon(),
                      const SizedBox(height: 40),

                      // Titre
                      Text(
                        'ما فماش كونكسيون',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      Text(
                        'تشيك عالكونكسيون وعاود',
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Bouton Réessayer
                      _buildRetryButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedWiFiIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6A67CE).withOpacity(0.3),
            const Color(0xFF6A67CE).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercles concentriques animés
          _buildAnimatedCircle(80, 2000),
          _buildAnimatedCircle(60, 1500),
          _buildAnimatedCircle(40, 1000),

          // Icon WiFi principal
          Image.asset('assets/images/wifi.png', width: 80, height: 80),

          // // Point d'exclamation
          // Positioned(
          //   top: 35,
          //   right: 35,
          //   child: Container(
          //     width: 24,
          //     height: 24,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFFF6B6B),
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: const Color(0xFF0F0F1E), width: 3),
          //     ),
          //     child: const Center(
          //       child: Text(
          //         '!',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, int duration) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF6A67CE).withOpacity(0.2 * (1 - value)),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(size / 2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Logique de réessai
          HapticFeedback.mediumImpact();
          _controller.reset();
          _controller.forward();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFF6A67CE).withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'عاود',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension pour utiliser le widget
class InternetAwareWidget extends StatelessWidget {
  final Widget child;
  final bool hasInternet;

  const InternetAwareWidget({
    super.key,
    required this.child,
    required this.hasInternet,
  });

  @override
  Widget build(BuildContext context) {
    return hasInternet ? child : const NoInternetScreen();
  }
}


// Dans votre app, utilisez ainsi :
// InternetAwareWidget(
//   hasInternet: connectionStatus,
//   child: VotreEcranPrincipal(),
// )