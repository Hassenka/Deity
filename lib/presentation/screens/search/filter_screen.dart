import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/logic/product_bloc/filter_bloc/filter_bloc.dart';
import 'package:diety/presentation/widgets/list_product_hor.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/presentation/widgets/gradient_snackbar.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Filter states
  Set<String> _selectedMeals = {};
  Set<String> _selectedIngredients = {};
  Set<String> _selectedMethods = {};
  Set<String> _selectedDiets = {};

  // Calorie range
  RangeValues _calorieRange = const RangeValues(200, 500);

  late AnimationController _animationController;
  late ScrollController _scrollController;
  bool _showScrollToTopButton = false;
  bool _showSearchButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 400 && !_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        } else if (_scrollController.offset <= 400 && _showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }

        // Logic to show/hide search button based on scroll direction
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_showSearchButton) setState(() => _showSearchButton = false);
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_showSearchButton) setState(() => _showSearchButton = true);
        }
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FilterBloc(),
        child: InternetConnectionWrapper(
          onReconnect: () {
            final bloc = context.read<FilterBloc>();
            // Only refetch if a filter has been applied previously
            if (bloc.state is FilterLoadSuccess) {
              bloc.add(
                ApplyFilters(
                  meals: _selectedMeals,
                  ingredients: _selectedIngredients,
                  methods: _selectedMethods,
                  diets: _selectedDiets,
                  kcalMin: _calorieRange.start.round(),
                  kcalMax: _calorieRange.end.round(),
                ),
              );
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: const RightSideDrawer(),
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .025,
                ),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .004,
                        ),
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
            floatingActionButton: _showScrollToTopButton
                ? FloatingActionButton(
                    heroTag: 'filter_fab', // Unique tag for this FAB
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  )
                : null,
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<FilterBloc, FilterState>(
                              builder: (context, state) {
                                if (state is FilterLoadSuccess &&
                                    state.recipes.isNotEmpty) {
                                  return _buildResultsHeader(context, state);
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            Wrap(
                              children: [
                                _buildMealSection(),
                                _buildCalorieSection(),
                                _buildIngredientsSection(),
                                _buildMethodsSection(),
                                _buildDietsSection(),
                              ],
                            ),
                            const SizedBox(height: 24),
                            BlocConsumer<FilterBloc, FilterState>(
                              listener: (context, state) {
                                if (state is FilterLoadFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      content: GradientSnackBarContent(
                                        message: 'Error: ${state.error}',
                                      ),
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is FilterLoadInProgress &&
                                    (state is! FilterLoadSuccess ||
                                        (state as FilterLoadSuccess)
                                            .recipes
                                            .isEmpty)) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (state is FilterLoadSuccess) {
                                  return Column(
                                    children: [
                                      _buildResultsSection(state.recipes),
                                      if (!state.hasReachedMax)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 24.0,
                                          ),
                                          child: state.isLoadingMore
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : _buildLoadMoreButton(context),
                                        ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _showSearchButton ? 100.0 : 0.0,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: _buildSearchButton(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection() {
    const meals = [
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
      selectedItems: _selectedMeals,
      onToggle: (item) => _toggleSelection(_selectedMeals, item),
    );
  }

  Widget _buildCalorieSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSectionTitle('وصفات حسب السعرات الحرارية لحصة واحدة'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
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
                      '${_calorieRange.end.round()} kcal',
                      // Min value, now on the left
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.darkBluePurple,
                        fontSize: 16,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      '${_calorieRange.start.round()} kcal',
                      // Max value, now on the right
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.darkBluePurple,
                        fontSize: 16,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E3FF), Color(0xFFFF4545)],
                            stops: [0.0, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40262F82),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6.0,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          rangeThumbShape: const RoundRangeSliderThumbShape(
                            enabledThumbRadius: 14,
                            elevation: 4.0,
                          ),
                          thumbColor: Colors.white,
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 0.0,
                          ),
                        ),
                        child: RangeSlider(
                          values: RangeValues(
                            700 - _calorieRange.end,
                            700 - _calorieRange.start,
                          ),
                          min: 0,
                          max: 700,
                          onChanged: (RangeValues values) {
                            setState(() {
                              _calorieRange = RangeValues(
                                700 - values.end,
                                700 - values.start,
                              );
                            });
                          },
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
    );
  }

  Widget _buildIngredientsSection() {
    const ingredients = [
      {'name': 'بالخضرة', 'image': 'assets/images/Broccoli.webp'},
      {'name': 'بالحم', 'image': 'assets/images/CutOfMeat.webp'},
      {'name': 'بالحوت', 'image': 'assets/images/TropicalFish.webp'},
      {'name': 'بالعجينة', 'image': 'assets/images/Bread.webp'},
    ];

    return _buildSection(
      title: 'وصفات حسب المكونات',
      children: ingredients,
      selectedItems: _selectedIngredients,
      onToggle: (item) => _toggleSelection(_selectedIngredients, item),
    );
  }

  Widget _buildMethodsSection() {
    const methods = [
      {'name': 'ساهلة', 'image': 'assets/images/OkHand.webp'},
      {'name': 'نهزها معايا', 'image': 'assets/images/Toolbox.webp'},
      {'name': 'شوية مكونات', 'image': 'assets/images/PinchingHand.webp'},
      {'name': 'من غير تطييب', 'image': 'assets/images/GreenSalad.webp'},
      {'name': 'فيسع فيسع', 'image': 'assets/images/Stopwatch.webp'},
      {'name': 'في الفور', 'image': 'assets/images/Pie.webp'},
    ];

    return _buildSection(
      title: 'وصفات حسب طريقة التحضير',
      children: methods,
      selectedItems: _selectedMethods,
      onToggle: (item) => _toggleSelection(_selectedMethods, item),
    );
  }

  Widget _buildDietsSection() {
    const diets = [
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
      selectedItems: _selectedDiets,
      onToggle: (item) => _toggleSelection(_selectedDiets, item),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> children,
    required Set<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 12,
            runSpacing: 12,
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 4),
          Divider(
            height: 5, // Defines the empty space around the divider
            thickness: 2, // Defines the thickness of the line
            color: AppColors.perpel,
            indent: 1, // Indent from the start of the line
            endIndent: 1, // Indent from the end of the line
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Color(0xFF262F82).withOpacity(0.075),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.trim(),
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  color: isSelected ? Colors.white : AppColors.darkBluePurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Dispatch the event to the FilterBloc
          context.read<FilterBloc>().add(
            ApplyFilters(
              meals: _selectedMeals,
              ingredients: _selectedIngredients,
              methods: _selectedMethods,
              diets: _selectedDiets,
              kcalMin: _calorieRange.start.round(),
              kcalMax: _calorieRange.end.round(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              elevation: 0,
              content: GradientSnackBarContent(
                message: 'جاري البحث...',
                icon: Icons.search,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },

        label: Text(
          'بحث',
          style: TextStyle(
            fontSize: 18,
            //fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.tajawal().fontFamily,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.search, color: Colors.white),
        style: ElevatedButton.styleFrom(
          // Consider adding this color to AppColors if it's a theme color
          backgroundColor: Color(0xFFA594F9),
          //  AppColors.primary, // Using AppColors.primary as an example, or define a new color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<FilterBloc>().add(LoadMoreFilterResults());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        'تحميل المزيد',
        style: TextStyle(
          fontSize: 18,
          fontFamily: GoogleFonts.tajawal().fontFamily,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, FilterLoadSuccess state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: null, // Not clickable
            icon: SvgPicture.asset(
              'assets/images/count.svg', // Replace with your actual SVG asset
              width: 23,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFA39),
                BlendMode.srcIn,
              ),
            ),
            label: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                children: [
                  TextSpan(
                    text: '${state.totalItems} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: 'وصفة متوفرة'),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
          const SizedBox(height: 6),
          // Reset button
          ElevatedButton.icon(
            onPressed: () => _resetAllFilters(context),
            icon: SvgPicture.asset(
              'assets/images/reset.svg', // Replace with your actual SVG asset
              width: 23,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFA39),
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              'إعادة كل الاختيارات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: GoogleFonts.tajawal().fontFamily,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(List<Recipes> recipes) {
    if (recipes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF5684EB).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF5684EB)),
        ),
        child: Text(
          'لم يتم العثور على وصفات تطابق بحثك. جرب تغيير الفلاتر.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            color: const Color(0xFF5684EB),
            fontSize: 18,
          ),
        ),
      );
    }

    final foodItems = recipes.map((recipe) {
      return FoodItem(
        id: recipe.id ?? 0,
        image: recipe.imgPath ?? 'https://via.placeholder.com/150',
        title: recipe.title ?? 'No Title',
        calories: recipe.kcal ?? 0,
        duration: recipe.totalTime ?? 0,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('نتائج البحث'),
        const SizedBox(height: 20),
        FoodListViewHor(
          foodItems: foodItems,
          onItemTap: (itemId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<FavoritesManager>(),
                  child: DetailScreen(recipeId: itemId),
                ),
              ),
            );
          },
        ),
      ],
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

  // This was not present in the web version, so it's commented out.
  // Can be re-added if a reset button is needed.
  void _resetAllFilters(BuildContext context) {
    setState(() {
      _selectedMeals.clear();
      _selectedIngredients.clear();
      _selectedMethods.clear();
      _selectedDiets.clear();
      _calorieRange = const RangeValues(200, 500);
    });
    context.read<FilterBloc>().add(ClearFilterResults());
  }
}
