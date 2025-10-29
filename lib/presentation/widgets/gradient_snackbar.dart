import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientSnackBarContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;

  const GradientSnackBarContent({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.99, -0.1), // Approximates 92.52deg
          end: Alignment(0.99, 0.1),
          stops: [0.1565, 0.2993, 0.4563, 0.8666],
          colors: [
            Color.fromRGBO(128, 218, 247, 0.08),
            Color.fromRGBO(255, 255, 255, 0.2),
            Color.fromRGBO(255, 255, 255, 0.2),
            Color.fromRGBO(255, 176, 228, 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: iconColor ?? Colors.black87),
          if (icon != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: GoogleFonts.tajawal().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
