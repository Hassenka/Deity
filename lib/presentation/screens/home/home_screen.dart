import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/screens/search/search_screen.dart';
import 'package:diety/presentation/widgets/calorie_selection_screen.dart';
import 'package:diety/presentation/widgets/list_product.dart';
import 'package:diety/presentation/widgets/list_product_hor.dart';
import 'package:diety/presentation/widgets/list_product_simple.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final List<CalorieData> CalorieItems1 = const [
    CalorieData(
      imagePath: 'assets/images/Cherries.webp',
      calorieRange: '50-0',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Watermelon.webp',
      calorieRange: '100-50',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Sandwich.webp',
      calorieRange: '200-100',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Bagel.webp',
      calorieRange: '300-200',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Stuffed.webp',
      calorieRange: '400-300',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Shallow.webp',
      calorieRange: '500-400',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Pot.webp',
      calorieRange: '600-500',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Spaghetti.webp',
      calorieRange: '700-600',
      check: true,
    ),
    CalorieData(
      imagePath: 'assets/images/Hamburger.webp',
      calorieRange: '+700',
      check: true,
    ),
  ];
  final List<CalorieData> CalorieItems2 = const [
    CalorieData(
      imagePath: 'assets/images/Broccoli.png',
      calorieRange: 'بالخضرة',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Cutofmeat.png',
      calorieRange: 'بالحم',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Tropicalfish.png',
      calorieRange: 'بالحوت',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Bread.png',
      calorieRange: 'بالعجينة',
      check: false,
    ),
  ];
  final List<CalorieData> CalorieItems3 = const [
    CalorieData(
      imagePath: 'assets/images/OkHand.webp',

      calorieRange: 'ساهلة',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Toolbox.png',
      calorieRange: 'نهزها معايا',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/PinchingHand.webp',
      calorieRange: 'شوية مكونات',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Greensalad.png',
      calorieRange: 'من غير تطييب ',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Stopwatch.png',
      calorieRange: 'فيسع فيسع',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Pie.png',
      calorieRange: 'في الفور',
      check: false,
    ),
  ];
  final List<CalorieData> CalorieItems4 = const [
    CalorieData(
      imagePath: 'assets/images/GreenApple.webp',
      calorieRange: 'قليل السعرات',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/LeafyGreen.webp',
      calorieRange: 'منخفض الدهون',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Peanuts.webp',
      calorieRange: 'منخفض الكربوهيدرات',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Cooking.webp',
      calorieRange: 'غني بالبروتين',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Eggplant.webp',
      calorieRange: 'غني بالألياف',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/sansSucre.webp',
      calorieRange: 'بدون سكر',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/sansLactose.webp',
      calorieRange: 'بدون لاكتوز',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/sansGluten.webp',
      calorieRange: 'بدون غلوتين',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Teacup.webp',
      calorieRange: 'دي توكس',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/PoultryLeg.webp',
      calorieRange: 'كيتو',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Fish.webp',
      calorieRange: 'بيكستر',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/CheeseWedge.webp',
      calorieRange: 'نباتي',
      check: false,
    ),
    CalorieData(
      imagePath: 'assets/images/Shamrock.webp',
      calorieRange: 'نباتي صارم',
      check: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: const RightSideDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .025,
          ),
          child: Align(
            alignment: AlignmentGeometry.topLeft,
            child: Image.asset(
              'assets/images/logo.png',
              height: MediaQuery.of(context).size.height * .04,
              fit: BoxFit.contain,
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9),
                    Text(
                      "كول إلي تحب، والدايت يبقى صحيح !",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.063,
                      ),

                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "إختار وجبتك حسب السعرات الحرارية، المكونات، طريقة التحضير ولا النظام الغذائي، وباش تلقى وصفات جاهزة مع خطوات التحضير.",

                      style: TextStyle(
                        color: AppColors.black,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        height: 1.75,
                        fontWeight: FontWeight.w800,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ), // px-5 py-1
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/settings-sliders.svg',
                                  width: 28,
                                  height: 28,
                                ),
                                SizedBox(width: 8), // mr-2 spacing
                                Text(
                                  "وجبتك على كيفك",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily:
                                        GoogleFonts.tajawal().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.053,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      "الوصفات الجدد",
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
                    FoodListView(),
                    SizedBox(height: 20),
                    Text(
                      "بروتينات وشيخات",
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
                    FoodListView(),
                    SizedBox(height: 20),
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
                    CalorieSelectionScreen(items: CalorieItems1),
                    SizedBox(height: 20),
                    Text(
                      "اختار سلاطتك",
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
                    FoodListView(),
                    SizedBox(height: 20),
                    Text(
                      "الهالثي بنين",
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
                    FoodListView(),
                    SizedBox(height: 20),
                    Text(
                      "الخفة والتقرميشة",
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
                    FoodListView(),
                    SizedBox(height: 20),
                    Text(
                      "حلي هالثي",
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
                    FoodListView(),
                    SizedBox(height: 20),

                    Text(
                      "اختار وجبتك",
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
                    FoodListViewsim(),
                    SizedBox(height: 20),

                    Text(
                      "وصفات حسب المكونات",
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
                    CalorieSelectionScreen(items: CalorieItems2),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Text(
                      "وصفات حسب طريقة التحضير",
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
                    CalorieSelectionScreen(items: CalorieItems3),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Text(
                      "وصفات حسب النظام الغذائي",
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
                    CalorieSelectionScreen(items: CalorieItems4),
                    SizedBox(height: 20),
                    Text(
                      "باش تشيخ بالبنة",
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
                    FoodListViewHor(),
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
}
