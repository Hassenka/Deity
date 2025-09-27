import 'package:flutter/material.dart';

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
        duration: const Duration(milliseconds: 300),
        width: 130,
        height: 130,
        padding: const EdgeInsets.all(12),
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
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.broken_image, size: 24),
                );
              },
            ),
            SizedBox(height: 15),
            Text(
              calorieRange,
              style: const TextStyle(
                color: textColor,
                fontSize: 18,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
            check
                ? Text(
                    'kcal',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

// Your updated, reusable CalorieSelectionScreen widget
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
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 46.0,
        runSpacing: 26.0,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          return CalorieCard(
            imagePath: item.imagePath,
            calorieRange: item.calorieRange,
            check: item.check,
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              print('${item.calorieRange} kcal card selected!');
            },
          );
        }),
      ),
    );
  }
}
