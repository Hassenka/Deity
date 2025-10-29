import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diety/presentation/screens/categorie/categorie_screen.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:provider/provider.dart';

/* ----------  MODEL  ---------- */
class CalorieData {
  final String imagePath;
  final String calorieRange;
  final bool check;

  const CalorieData({
    required this.imagePath,
    required this.calorieRange,
    required this.check,
  });
}

/* ----------  CARD  ---------- */
class CalorieCard extends StatelessWidget {
  final String imagePath;
  final String calorieRange;
  final bool check;
  final bool isSelected;
  final VoidCallback onTap;

  const CalorieCard({
    super.key,
    required this.imagePath,
    required this.calorieRange,
    required this.check,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF262F82);
    final selectedColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ----  image  ---- */
            Image.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 24),
            ),

            const SizedBox(height: 8), // reduced from 15
            /* ----  texts  ---- */
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    calorieRange,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.1, // tighter line-spacing
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                    ),
                  ),
                  if (check)
                    Text(
                      'kcal',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------  GRID  ---------- */
class CalorieSelectionScreen extends StatefulWidget {
  final List<CalorieData> items;
  const CalorieSelectionScreen({super.key, required this.items});

  @override
  State<CalorieSelectionScreen> createState() => _CalorieSelectionScreenState();
}

class _CalorieSelectionScreenState extends State<CalorieSelectionScreen> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0, // card is square
        ),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return CalorieCard(
            imagePath: item.imagePath,
            calorieRange: item.calorieRange,
            check: item.check,
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() => _selectedIndex = index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: context.read<FavoritesManager>(),
                    child: CategorieScreen(categoryName: item.calorieRange),
                  ),
                ),
              );
              debugPrint('${item.calorieRange} kcal card selected!');
            },
          );
        },
      ),
    );
  }
}
