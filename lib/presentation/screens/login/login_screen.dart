import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/logic/product_bloc/login_bloc/auth_bloc.dart';
import 'package:diety/presentation/widgets/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _loadCredentials() async {
    final credentials = await _sessionManager.getCredentials();
    if (credentials != null) {
      _phoneController.text = credentials['phone']!;
      _passwordController.text = credentials['password']!;
      setState(() => _rememberMe = true);
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: Container(
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
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => NotificationProvider(),
                              ),
                              ChangeNotifierProvider.value(
                                value: FavoritesManager(),
                              ), // Use .value for singleton
                            ],
                            child:
                                const MainScreen(), // MainScreen will now have access to both
                          ),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      _showErrorSnackBar(context, state.error);
                    }
                  },
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.red, width: 1),
        ),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
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
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header: "مرحبا بيك !" ---
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.lineGrey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'مرحبا بيك !',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        color: AppColors.textBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.lineGrey)),
                ],
              ),
              const SizedBox(height: 24),

              // --- Phone Number Field ---
              Text(
                'رقم الجوال',
                style: TextStyle(
                  color: AppColors.labelBlue,
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                textAlign: TextAlign.right,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.username],
                decoration: _buildInputDecoration(
                  hintText: 'رقم الجوال',
                  icon: Icons.phone_iphone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الجوال';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Password Field ---
              Text(
                'كلمة المرور',
                style: TextStyle(
                  color: AppColors.labelBlue,
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                textAlign: TextAlign.right,
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                autofillHints: const [AutofillHints.password],
                decoration: _buildInputDecoration(
                  hintText: 'كلمة المرور',
                  // Use the visibility icon as a toggle button
                  iconWidget: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.labelBlue,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  return null;
                },
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
                      Text(
                        'الحفاظ على تسجيل الدخول',
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                        ),
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
                          color: AppColors.primaryBlue,
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Login Button ---
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              // When the user logs in, we can ask the platform to save the credentials.
                              TextInput.finishAutofillContext();
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  phoneNumber: _phoneController.text,
                                  password: _passwordController.text,
                                  rememberMe: _rememberMe,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? AppColors.primaryBlue
                          : AppColors.disabledGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'الدخول',
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Service Activation Info ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBlue),
                ),
                child: Column(
                  children: [
                    Text(
                      'تحب تستمتع بالخدمة ؟',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'إتصل بالرقم التالي #0*000*',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        color: AppColors.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
