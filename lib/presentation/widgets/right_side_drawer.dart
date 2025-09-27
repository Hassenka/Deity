import 'package:diety/presentation/screens/profile/profile_screen.dart';
import 'package:diety/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RightSideDrawer extends StatelessWidget {
  const RightSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // apply RTL globally
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          children: <Widget>[
            const SizedBox(height: 20),

            _buildDrawerItem(
              context: context,
              icon: Icons.favorite_border,
              title: 'وصفاتي',
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              context: context,
              icon: Icons.notifications_none_outlined,
              title: 'إشعاراتي',
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              context: context,
              icon: Icons.person_outline,
              title: 'حسابي',
              screen: ProfileScreen(),
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              context: context,
              icon: Icons.filter_list,
              title: 'فلترى',
              screen: FilterScreen(),
            ),
            const SizedBox(height: 20),

            // Search field
            TextField(
              style: TextStyle(fontFamily: 'Tajawal'),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'البحث بالاسم، أو المكونات، أو الفئة',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                // for RTL we swap prefix/suffix meaning
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.close, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? screen,
  }) {
    return InkWell(
      onTap: () {
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF333333), size: 28),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
