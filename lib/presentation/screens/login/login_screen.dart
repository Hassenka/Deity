import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/widgets/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    // Define colors from the website for consistency

    return Scaffold(
      body: Container(
        // This container creates the background gradient from the website's theme
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F0FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLoginForm(
                AppColors.lineGrey,
                AppColors.textBlue,
                AppColors.labelBlue,
                AppColors.primaryBlue,
                AppColors.disabledGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Extracted the form into a builder method for cleaner code
  Widget _buildLoginForm(
    Color lineGrey,
    Color textBlue,
    Color labelBlue,
    Color primaryBlue,
    Color disabledGrey,
  ) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: primaryBlue.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Header: "مرحبا بيك !" ---
          Row(
            children: [
              Expanded(child: Divider(color: lineGrey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'مرحبا بيك !',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    color: textBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Divider(color: lineGrey)),
            ],
          ),
          const SizedBox(height: 24),

          // --- Phone Number Field ---
          Text(
            'رقم الجوال',
            style: TextStyle(
              color: labelBlue,
              fontFamily: GoogleFonts.tajawal().fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            textAlign: TextAlign.right,
            keyboardType: TextInputType.phone,
            decoration: _buildInputDecoration(
              hintText: 'رقم الجوال',
              icon: Icons.phone_iphone_outlined,
            ),
          ),
          const SizedBox(height: 16),

          // --- Password Field ---
          Text(
            'كلمة المرور',
            style: TextStyle(
              color: labelBlue,
              fontFamily: GoogleFonts.tajawal().fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            textAlign: TextAlign.right,
            obscureText: !_isPasswordVisible,
            decoration: _buildInputDecoration(
              hintText: 'كلمة المرور',
              // Use the visibility icon as a toggle button
              iconWidget: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: labelBlue,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Remember Me & Forgot Password ---
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text(
                    'الحفاظ على تسجيل الدخول',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'نسيت كلمة المرور ؟',
                    style: TextStyle(
                      color: primaryBlue,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Login Button ---
          ElevatedButton(
            // The button is disabled as per the HTML design
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: disabledGrey,
              disabledBackgroundColor: disabledGrey,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'الدخول',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Service Activation Info ---
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryBlue),
            ),
            child: Column(
              children: [
                Text(
                  'تحب تستمتع بالخدمة ؟',
                  style: TextStyle(
                    color: primaryBlue,
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'إتصل بالرقم التالي #0*000*',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for consistent input field styling
  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? icon,
    Widget? iconWidget,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0x0D007AFF), // Light blue fill
      // In RTL, prefixIcon appears on the right
      prefixIcon:
          iconWidget ??
          (icon != null ? Icon(icon, color: const Color(0xFF262F82)) : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF262F82)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF262F82)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
      ),
    );
  }
}
