import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/logic/product_bloc/profil_bloc/profile_bloc.dart';
import 'package:diety/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diety/presentation/widgets/gradient_snackbar.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext sheetContext, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    // Close the bottom sheet first.
    // ignore: use_build_context_synchronously
    Navigator.of(sheetContext).pop();

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final fileSizeInBytes = await imageFile.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 2) {
        // If the file is too large, show an error and don't proceed.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: GradientSnackBarContent(
                message: 'حجم الصورة كبير جدا (الحد الأقصى 2 ميجابايت).',
                icon: Icons.error_outline,
              ),
            ),
          );
        }
      } else {
        // If the file size is acceptable, set it for preview and upload.
        setState(() => _selectedImageFile = imageFile);
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () => _pickImage(sheetContext, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors from the website for consistency
    const Color primaryBlue = Color(0xFF007AFF);
    const Color lightText = Color(0x6E262F82);
    const Color lightGreyButton = Color(0xFFBAC1CB);

    return BlocProvider(
      create: (context) => ProfileBloc()..add(ProfileLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 1,
          centerTitle: true,
          title: Text(
            'الحساب الشخصي',
            style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.black,
              ), // This icon points back in RTL
              onPressed: () => Navigator.of(
                context,
              ).pop(), // Simply pop the current screen to return
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoadSuccess) {
              _nameController.text = state.user.name;
              _phoneController.text = state.user.phoneNumber.toString();
              // If the profile reloads successfully after an update, clear the local image selection.
              if (_selectedImageFile != null) {
                setState(() {
                  _selectedImageFile = null;
                });
              }
            }
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: GradientSnackBarContent(
                    message: 'تم تحديث الملف الشخصي بنجاح!',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              );
            }
            if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: GradientSnackBarContent(
                    message: state.error,
                    icon: Icons.error_outline,
                  ),
                ),
              );
            }
            if (state is ProfileLogoutSuccess) {
              // Navigate to the login screen and remove all previous routes
              // to prevent the user from going back to a logged-in screen.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoadInProgress || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoadFailure) {
              return const Center(child: Text('فشل تحميل الملف الشخصي.'));
            }
            // This condition now correctly handles all states that contain user data.
            if (state is ProfileLoadSuccess ||
                state is ProfileUpdateInProgress ||
                state is ProfileUpdateFailure) {
              // Extract user data regardless of the specific state type
              final user = (state as dynamic).user;

              return Directionality(
                textDirection: TextDirection.rtl, // apply RTL globally
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 23.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Text(
                            'مرحبا بيك في حسابك الخاص',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 24,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Column(
                            children: [
                              if (_selectedImageFile != null)
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(
                                    _selectedImageFile!,
                                  ),
                                )
                              else if (user.image != null)
                                CachedNetworkImage(
                                  imageUrl: user.image!,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: imageProvider,
                                      ),
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                        radius: 40,
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      _buildPlaceholderAvatar(primaryBlue),
                                )
                              else
                                _buildPlaceholderAvatar(primaryBlue),
                              const SizedBox(height: 8),
                              Text(
                                'إتنجم تحمل وإلا تغير صورتك حسابك\nبصيغة webp , jpeg أو png.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: lightText.withOpacity(0.7),
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: state is ProfileUpdateInProgress
                                    ? null
                                    : () {
                                        if (_selectedImageFile != null) {
                                          // This is the "Confirm Upload" action
                                          context.read<ProfileBloc>().add(
                                            ProfileImageUpdateRequested(
                                              imageFile: _selectedImageFile!,
                                            ),
                                          );
                                        } else {
                                          // This is the "Upload Image" action
                                          _showImagePickerOptions();
                                        }
                                      },
                                icon: const Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child: Icon(
                                    Icons.upload_file_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                label: Text(
                                  _selectedImageFile == null
                                      ? 'تحميل صورة'
                                      : 'تأكيد تحميل الصورة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.tajawal().fontFamily,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  alignment: Alignment.center,
                                  minimumSize: const Size(280, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'الإسم',
                            style: TextStyle(
                              color: lightText.withOpacity(0.7),
                              fontSize: 16,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _nameController,
                          textAlign: TextAlign.right,
                          decoration: _buildInputDecoration(hintText: 'الإسم'),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            textAlign: TextAlign.right,
                            'رقم الجوال',
                            style: TextStyle(
                              color: lightText.withOpacity(0.7),
                              fontSize: 16,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _phoneController,
                          enabled:
                              false, // Use enabled: false instead of readOnly
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.phone,
                          decoration: _buildInputDecoration(
                            hintText: '10 10 10 10',
                            prefixIcon: const Icon(
                              Icons.phone_iphone,
                              color: lightText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: state is ProfileUpdateInProgress
                              ? null
                              : () {
                                  context.read<ProfileBloc>().add(
                                    ProfileUpdateRequested(
                                      name: _nameController.text,
                                      phoneNumber: _phoneController.text,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is ProfileUpdateInProgress
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'تغير الاسم',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.tajawal().fontFamily,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(LogoutRequested());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightGreyButton,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink(); // Should not be reached
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(Color primaryBlue) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 38,
        backgroundColor: const Color(0xFFF0F6FF),
        child: Icon(Icons.person_outline, size: 36, color: primaryBlue),
      ),
    );
  }

  // Helper method to avoid repetitive decoration code
  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0x0D007AFF), // Light blue fill
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0x6E183153).withOpacity(0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0x6E183153).withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        // Style for the disabled phone number field
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0x6E183153).withOpacity(0.2)),
      ),
    );
  }
}
