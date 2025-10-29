import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/presentation/widgets/list_product_hor.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:diety/presentation/widgets/main_menu_screen.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:flutter/material.dart';
import 'package:diety/core/constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// End of assumed classes

class FavoriteRecipesScreen extends StatefulWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  State<FavoriteRecipesScreen> createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;
  bool _showScrollToTopButton = false;

  late Future<Recipe> _favoritesFuture;
  final ApiService _apiService = ApiService();
  List<Recipes> _allRecipes = [];

  String _selectedCategory = '❤️  كل وصفاتي';

  // Consider fetching categories from an API or a shared constant file
  final List<Map<String, String>> _categories = favoriteRecipeCategories;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
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
      });
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _apiService.getMySaves();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InternetConnectionWrapper(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const RightSideDrawer(),
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .025,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (_) => NotificationProvider(),
                          ),
                          ChangeNotifierProvider.value(
                            value: FavoritesManager(),
                          ),
                        ],
                        child: const MainScreen(),
                      ),
                    ),
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
                  heroTag: 'favorites_fab', // Unique tag for this FAB
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
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Page Title ---
                  Text(
                    'وصفاتي المفضلة',
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
                    height: 2, // Defines the empty space around the divider
                    thickness: 2, // Defines the thickness of the line
                    color: AppColors.perpel,
                    indent: 1, // Indent from the start of the line
                    endIndent: 1, // Indent from the end of the line
                  ),
                  const SizedBox(height: 16),

                  // --- Filter Chips ---
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: _categories.map((category) {
                      return _buildCategoryChip(
                        label: category['name']!,
                        iconPath: category['icon']!,
                        isSelected: _selectedCategory == category['name'],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Consumer<FavoritesManager>(
                    builder: (context, favoritesManager, child) {
                      return FutureBuilder<Recipe>(
                        future: _favoritesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            _allRecipes = snapshot.data!.recipes != null
                                ? snapshot.data!.recipes!
                                : [];

                            if (_allRecipes
                                .where(
                                  (r) => favoritesManager.isFavorite(r.id!),
                                )
                                .isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5684EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'حاليا، الموندو متاعك، كيفاش أنقولوها، ومن غير نبزيات ... مافيهوش وصفات. متنساش، الوصفات إلي يعجبوك أعمل عليهم جام، هكة يتسجللك ديراكت. أوكي',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }

                            final List<Recipes> filteredRecipes;
                            if (_selectedCategory == '❤️  كل وصفاتي') {
                              filteredRecipes = _allRecipes
                                  .where(
                                    (r) => favoritesManager.isFavorite(r.id!),
                                  )
                                  .toList();
                            } else {
                              filteredRecipes = _allRecipes.where((recipe) {
                                return recipe.typeRepas?.any(
                                      (type) => type.title == _selectedCategory,
                                    ) ??
                                    false;
                              }).toList();
                            }

                            if (filteredRecipes.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5684EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'حاليا، الموندو متاعك، كيفاش أنقولوها، ومن غير نبزيات ... مافيهوش وصفات. متنساش، الوصفات إلي يعجبوك أعمل عليهم جام، هكة يتسجللك ديراكت. أوكي',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }

                            final foodItems = filteredRecipes.map((recipe) {
                              return FoodItem(
                                id: recipe.id ?? 0,
                                image: recipe.imgPath ?? '',
                                title: recipe.title ?? 'No Title',
                                calories: recipe.kcal ?? 0,
                                duration: recipe.totalTime ?? 0,
                              );
                            }).toList();

                            return FoodListViewHor(
                              foodItems: foodItems,
                              onItemTap: (itemId) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChangeNotifierProvider.value(
                                          value: context
                                              .read<FavoritesManager>(),
                                          child: DetailScreen(recipeId: itemId),
                                        ),
                                  ),
                                );
                              },
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String iconPath,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.disabledGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  color: isSelected ? Colors.white : AppColors.darkBluePurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (iconPath.isNotEmpty) const SizedBox(width: 8),
              if (iconPath.isNotEmpty)
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
