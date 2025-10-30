import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/user_model.dart';
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/presentation/screens/login/login_screen.dart';
import 'package:diety/presentation/screens/profile/profile_screen.dart';
import 'package:diety/presentation/screens/terms/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class RightSideDrawer extends StatefulWidget {
  // ignore: use_super_parameters
  const RightSideDrawer({Key? key}) : super(key: key);

  @override
  State<RightSideDrawer> createState() => _RightSideDrawerState();
}

class _RightSideDrawerState extends State<RightSideDrawer> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await SessionManager().getUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // apply RTL globally
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          children: <Widget>[
            if (_user != null)
              _buildUserHeader(context, _user!)
            else
              const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),

            Divider(
              height: 5, // Defines the empty space around the divider
              thickness: 2, // Defines the thickness of the line
              color: AppColors.perpel,
              indent: 1, // Indent from the start of the line
              endIndent: 1, // Indent from the end of the line
            ),
            const SizedBox(height: 20),

            // _buildDrawerItem(
            //   context: context,
            //   icon: 'assets/images/heart-3.png',
            //   title: 'وصفاتي',
            //   screen: FavoriteRecipesScreen(),
            // ),
            // const SizedBox(height: 10),
            // _buildDrawerItem(
            //   context: context,
            //   icon: 'assets/images/bell-3.png',
            //   title: 'إشعاراتي',
            //   screen: IngredientsApp(),
            // ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              context: context,
              icon: 'assets/images/mimou.svg',
              //face-menu.svg',
              title: 'حسابي',
              screen: ProfileScreen(),
            ),
            // const SizedBox(height: 10),
            // _buildDrawerItem(
            //   context: context,
            //   icon: 'assets/images/settings-sliders 1 (1).png',
            //   title: 'فلترى',
            //   screen: NoInternetScreen(),
            // ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              context: context,
              icon: 'assets/images/center.svg',
              //prv_menu.svg',
              title: 'سياسة الخصوصية',
              screen: TermsScreen(),
            ),

            // const SizedBox(height: 10),
            // _buildDrawerItem(
            //   context: context,
            //   icon: 'assets/images/receipt.png',
            //   title: 'سياسة الخصوصية',
            //   screen: IngredientsApp(),
            // ),
            const SizedBox(height: 20),
            Divider(
              height: 5, // Defines the empty space around the divider
              thickness: 2, // Defines the thickness of the line
              color: AppColors.perpel,
              indent: 1, // Indent from the start of the line
              endIndent: 1, // Indent from the end of the line
            ),
            const SizedBox(height: 20),

            _buildDrawerItem(
              context: context,
              icon: 'assets/images/out.svg',
              //out_side_menu.svg',
              title: 'تسجيل الخروج',
              screen: LoginScreen(),
              onTap: () async {
                // Clear all session data
                await SessionManager().clearSession();
                // Navigate to Login and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
            // _buildDrawerItem(
            //   context: context,
            //   //icon: 'assets/images/receipt.png',
            //   title: 'test hors connection',
            //   screen: NoInternetScreen(),
            //   icon: 'assets/images/out_menu.svg',
            // ),
            const SizedBox(height: 10),

            // Search field
            // TextField(
            //   style: TextStyle(fontFamily: 'Tajawal'),
            //   textAlign: TextAlign.right,
            //   decoration: InputDecoration(
            //     hintText: 'البحث بالاسم، أو المكونات، أو الفئة',
            //     hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            //     // for RTL we swap prefix/suffix meaning
            //     prefixIcon: const Icon(Icons.search, color: Colors.grey),
            //     suffixIcon: const Icon(Icons.close, color: Colors.grey),
            //     contentPadding: const EdgeInsets.symmetric(vertical: 10),
            //     enabledBorder: const UnderlineInputBorder(
            //       borderSide: BorderSide(color: Colors.grey),
            //     ),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(color: Colors.blue),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        // Navigate to profile screen
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.lightGray,
              child: user.image != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user.image!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person, color: AppColors.grey),
                      ),
                    )
                  : const Icon(Icons.person, size: 28, color: AppColors.grey),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا بيك,',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String icon,
    required String title,
    Widget? screen,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            // Close the drawer first
            Navigator.of(context).pop();
            // Then push the new screen
            if (screen != null)
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => screen));
          },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ), // Space between icon and text'),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontSize: 20,
              //fontWeight: FontWeight.w900,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
