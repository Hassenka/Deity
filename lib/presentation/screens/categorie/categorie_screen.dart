import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/logic/product_bloc/categorie_bloc/categorie_bloc.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:diety/presentation/widgets/list_product_hor.dart';
import 'package:diety/presentation/widgets/main_menu_screen.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategorieScreen extends StatelessWidget {
  final String categoryName;
  const CategorieScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategorieBloc()..add(FetchRecipesByCategory(categoryName)),
      child: _CategorieScreenView(categoryName: categoryName),
    );
  }
}

class _CategorieScreenView extends StatefulWidget {
  final String categoryName;
  const _CategorieScreenView({required this.categoryName});

  @override
  State<_CategorieScreenView> createState() => __CategorieScreenViewState();
}

class __CategorieScreenViewState extends State<_CategorieScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;
  bool _showScrollToTopButton = false;

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
        onReconnect: () => context.read<CategorieBloc>().add(
          FetchRecipesByCategory(widget.categoryName),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const RightSideDrawer(),
          floatingActionButton: _showScrollToTopButton
              ? FloatingActionButton(
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
                          ), // Use .value for singleton
                        ],
                        child:
                            const MainScreen(), // MainScreen will now have access to both
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
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryName,
                  style: TextStyle(
                    color: AppColors.perpel,
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.063,
                  ),
                  textAlign: TextAlign.right,
                ),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: AppColors.perpel,
                  indent: 1,
                  endIndent: 1,
                ),
                const SizedBox(height: 20),
                BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is CategorieLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CategorieLoadFailure) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    if (state is CategorieLoadSuccess) {
                      if (state.recipes.isEmpty) {
                        return const Center(
                          child: Text('لا توجد وصفات في هذه الفئة.'),
                        );
                      }
                      final foodItems = state.recipes.map((recipe) {
                        return FoodItem(
                          id: recipe.id ?? 0,
                          image: recipe.imgPath ?? '',
                          title: recipe.title ?? 'No Title',
                          calories: recipe.kcal ?? 0,
                          duration: recipe.totalTime ?? 0,
                        );
                      }).toList();
                      return Column(
                        children: [
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
                          if (!state.hasReachedMax)
                            const SizedBox(
                              height: 20,
                            ), // This now uses the getter
                          if (!state.hasReachedMax)
                            _buildLoadMoreButton(context),
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
      ),
    );
  }
}

Widget _buildLoadMoreButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.read<CategorieBloc>().add(LoadMoreRecipesByCategory());
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
