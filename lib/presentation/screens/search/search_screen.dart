import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/screens/home/home_screen.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // A GlobalKey is needed to open the drawer programmatically
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Filter states
  Set<String> selectedMeals = {'فطور الصباح', 'عشاء', 'ديسار'};
  Set<String> selectedIngredients = {'بالحم', 'بالحوت'};
  Set<String> selectedMethods = {'ساهلة', 'نهزها معايا', 'شوية مكونات'};
  Set<String> selectedDiets = {
    'منخفض الدهون',
    'غني بالألياف',
    'بدون سكر',
    'دي توكس',
  };

  // Calorie range
  RangeValues calorieRange = const RangeValues(0, 700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Using endDrawer makes it open from the right
      drawer: const RightSideDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .025,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Align(
              alignment: AlignmentGeometry.topLeft,
              child: Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height * .04,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 4,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),

            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .08,
                    height: MediaQuery.of(context).size.height * .007,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .004),
                  Container(
                    width: MediaQuery.of(context).size.width * .08,
                    height: MediaQuery.of(context).size.height * .007,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopButtons("وجبتك على كيفك", "rafraichir.png"),
                    SizedBox(height: 10),
                    _buildTopButtons(
                      " وصفة متوفرة وفقًا لخيارات",
                      "restaurant.png",
                    ),
                    SizedBox(height: 10),
                    _buildMealSection(),
                    _buildCalorieSection(),
                    _buildIngredientsSection(),
                    _buildMethodsSection(),
                    _buildDietsSection(),
                    SizedBox(height: 20),
                    _buildTopButtons("وجبتك على كيفك", "rafraichir.png"),
                    SizedBox(height: 10),
                    _buildTopButtons(
                      " وصفة متوفرة وفقًا لخيارات",
                      "restaurant.png",
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopButtons(String titre, String image) {
    return GestureDetector(
      onTap: () {
        _resetAllFilters();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), // px-5 py-1
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/$image'),
                SizedBox(width: 8), // mr-2 spacing
                Text(
                  titre,
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.053,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection() {
    final meals = [
      {'name': 'فطور الصباح', 'image': 'assets/images/coffe.webp'},
      {'name': 'غداء', 'image': 'assets/images/ShallowPan.webp'},
      {'name': 'عشاء', 'image': 'assets/images/PotOfFood.webp'},
      {'name': 'لمجة', 'image': 'assets/images/Chestnut.webp'},
      {'name': 'سلاطة', 'image': 'assets/images/GreenSalad.webp'},
      {'name': 'شوربة', 'image': 'assets/images/BowlWithSpoon.webp'},
      {'name': 'ديسار', 'image': 'assets/images/Cupcake.webp'},
    ];

    return _buildSection(
      title: 'اختار وجبتك',
      children: meals,
      selectedItems: selectedMeals,
      onToggle: (item) => _toggleSelection(selectedMeals, item),
    );
  }

  Widget _buildCalorieSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "وصفات حسب السعرات الحرارية لحصة واحدة",
            style: TextStyle(
              color: AppColors.perpel,
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.063,
            ),
            textAlign: TextAlign.right,
          ),

          Divider(
            height: 20, // Defines the empty space around the divider
            thickness: 2, // Defines the thickness of the line
            color: AppColors.perpel,
            indent: 1, // Indent from the start of the line
            endIndent: 1, // Indent from the end of the line
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.greyslid,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${calorieRange.start.round()} kcal',
                      style: TextStyle(
                        color: Color(0xFF262F82),
                        fontSize: 18,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                    Text(
                      '${calorieRange.end.round()} kcal',
                      style: TextStyle(
                        color: Color(0xFF262F82),
                        fontSize: 18,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9, // w-[90%]
                      constraints: BoxConstraints(
                        maxWidth: 600, // ~ md:w-[65%]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 40, // Enough height for the slider thumb
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        Color(0xFFFF4545),
                                        Color(0xFF00E3FF),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x40262F82),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        // inset: true,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                RangeSlider(
                                  values: calorieRange,
                                  min: 0,
                                  max: 700,
                                  divisions: 700,
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      calorieRange = values;
                                      print(" values $values ");
                                    });
                                  },
                                  activeColor: Colors.transparent,
                                  inactiveColor: Colors.transparent,
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), // Closing bracket for the Container
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    final ingredients = [
      {'name': 'بالخضرة', 'image': 'assets/images/Broccoli.webp'},
      {'name': 'بالحم', 'image': 'assets/images/CutOfMeat.webp'},
      {'name': 'بالحوت', 'image': 'assets/images/TropicalFish.webp'},
      {'name': 'بالعجينة', 'image': 'assets/images/Bread.webp'},
    ];

    return _buildSection(
      title: 'وصفات حسب المكونات',
      children: ingredients,
      selectedItems: selectedIngredients,
      onToggle: (item) => _toggleSelection(selectedIngredients, item),
    );
  }

  Widget _buildMethodsSection() {
    final methods = [
      {'name': 'ساهلة', 'image': 'assets/images/OkHand.webp'},
      {'name': 'نهزها معايا', 'image': 'assets/images/Toolbox.webp'},
      {'name': 'شوية مكونات', 'image': 'assets/images/PinchingHand.webp'},
      {'name': 'من غير تطييب ', 'image': 'assets/images/GreenSalad.webp'},
      {'name': 'فيسع فيسع', 'image': 'assets/images/Stopwatch.webp'},
      {'name': 'في الفور', 'image': 'assets/images/Pie.webp'},
    ];

    return _buildSection(
      title: 'وصفات حسب طريقة التحضير',
      children: methods,
      selectedItems: selectedMethods,
      onToggle: (item) => _toggleSelection(selectedMethods, item),
    );
  }

  Widget _buildDietsSection() {
    final diets = [
      {'name': 'قليل السعرات', 'image': 'assets/images/GreenApple.webp'},
      {'name': 'منخفض الدهون', 'image': 'assets/images/LeafyGreen.webp'},
      {'name': 'منخفض الكربوهيدرات', 'image': 'assets/images/Peanuts.webp'},
      {'name': 'غني بالبروتين', 'image': 'assets/images/Cooking.webp'},
      {'name': 'غني بالألياف', 'image': 'assets/images/Eggplant.webp'},
      {'name': 'بدون سكر', 'image': 'assets/images/sansSucre.webp'},
      {'name': 'بدون لاكتوز', 'image': 'assets/images/sansLactose.webp'},
      {'name': 'بدون غلوتين', 'image': 'assets/images/sansGluten.webp'},
      {'name': 'دي توكس', 'image': 'assets/images/Teacup.webp'},
      {'name': 'كيتو', 'image': 'assets/images/PoultryLeg.webp'},
      {'name': 'بيكستر', 'image': 'assets/images/Fish.webp'},
      {'name': 'نباتي', 'image': 'assets/images/CheeseWedge.webp'},
      {'name': 'نباتي صارم', 'image': 'assets/images/Shamrock.webp'},
    ];

    return _buildSection(
      title: 'وصفات حسب النظام الغذائي',
      children: diets,
      selectedItems: selectedDiets,
      onToggle: (item) => _toggleSelection(selectedDiets, item),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> children,
    required Set<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: AppColors.perpel,
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.063,
            ),
            textAlign: TextAlign.right,
          ),

          Divider(
            height: 20, // Defines the empty space around the divider
            thickness: 2, // Defines the thickness of the line
            color: AppColors.perpel,
            indent: 1, // Indent from the start of the line
            endIndent: 1, // Indent from the end of the line
          ),
          SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: children.map((item) {
              final isSelected = selectedItems.contains(item['name']);
              return _buildFilterChip(
                label: item['name']!,
                imagePath: item['image'] ?? item['icon'] ?? '',
                isSelected: isSelected,
                onTap: () => onToggle(item['name']!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.backgroundGray.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              child: Image.asset(
                imagePath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                color: isSelected ? Colors.white : AppColors.perpel,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(Set<String> set, String item) {
    setState(() {
      if (set.contains(item)) {
        set.remove(item);
      } else {
        set.add(item);
      }
    });
  }

  void _resetAllFilters() {
    setState(() {
      selectedMeals.clear();
      selectedIngredients.clear();
      selectedMethods.clear();
      selectedDiets.clear();
      calorieRange = RangeValues(200, 500);
    });
  }

  //int _getFilteredCount() {
  // Mock calculation based on selected filters
  //int baseCount = 18;
  //int filterCount =
  // selectedMeals.length +
  // selectedIngredients.length +
  // selectedMethods.length +
  // selectedDiets.length;
  //return (baseCount - (filterCount * 0.5)).round().clamp(1, 50);
  //}

  // void _showResults() {
  // Navigate to results screen or show filtered recipes
  //ScaffoldMessenger.of(context).showSnackBar(
  //SnackBar(
  //content: Text('عرض ${_getFilteredCount()} وصفة متوفرة'),
  // backgroundColor: AppColors.titlecard,
  //),
  //);
  //}
}
