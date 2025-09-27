import 'package:diety/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define colors from the website for consistency
    const Color primaryBlue = Color(0xFF007AFF);
    const Color lightText = Color(0x6E262F82);
    const Color lightGreyButton = Color(0xFFBAC1CB);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'الحساب الشخصي',
          style: TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.tajawal().fontFamily,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // apply RTL globally
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    'مرحبا بيك في حسابك الخاص',
                    style: TextStyle(
                      color: const Color(0xFF7695FF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- Profile Picture Section ---
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        // A border that matches the design
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xFFF0F6FF),
                          child: Icon(
                            Icons.person_outline,
                            size: 36,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'إتنجم تحمل وإلا تغير صورتك حسابك\nبصيغة webp , jpeg أو png.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: lightText,
                          fontSize: 13,
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.upload_file_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          'تحميل صورة',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
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

                // --- Form Section ---
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'الإسم',
                    style: TextStyle(
                      color: lightText,
                      fontSize: 14,
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
                      color: lightText,
                      fontSize: 14,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
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

                // --- Action Buttons ---
                ElevatedButton(
                  onPressed: () {
                    // Handle name change logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'تغير الاسم',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle logout logic
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
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "مرحبا بيكم على دايتي ! تحبوا تتمتعوا بأكلات بنينة وتعرفوا في نفس الوقت على السعرات الحرارية وكل المكونات الغذائية لكل وصفة. تلقاوا عندنا أحسن الوصفات الصحية مع كل المعلومات الغذائية إلي تحتاجوها. معانا، كل شيء متوازن وبنين !",
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    height: 1.75,
                    fontWeight: FontWeight.w800,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
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
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0x6E183153).withOpacity(0.2)),
      ),
    );
  }
}
