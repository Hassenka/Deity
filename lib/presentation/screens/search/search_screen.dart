import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:diety/data/models/recipe_model.dart'; // For Recipes type
import 'package:diety/logic/product_bloc/search_bloc/search_bloc.dart';
import 'package:diety/presentation/widgets/list_product_hor.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:logger/logger.dart'; // Import logger
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Search Results Screen ---

// Initialize a logger instance for this file
final _logger = Logger();

class DietySearchScreen extends StatelessWidget {
  final List<Recipes>? recipes;
  const DietySearchScreen({super.key, this.recipes});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(), // Bloc is created here
      child: _DietySearchScreenView(initialRecipes: recipes),
    );
  }
}

class _DietySearchScreenView extends StatefulWidget {
  final List<Recipes>? initialRecipes;
  const _DietySearchScreenView({this.initialRecipes});

  @override
  State<_DietySearchScreenView> createState() => __DietySearchScreenViewState();
}

class __DietySearchScreenViewState extends State<_DietySearchScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  List<Recipes> _initialRecipes = [];
  // ignore: unused_field
  late ScrollController _scrollController;
  bool _showScrollToTopButton = false;
  // ignore: unused_field
  String? _token;

  void _searchListener() {
    setState(() {}); // Rebuild to show/hide the search query title
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    if (widget.initialRecipes != null) {
      _initialRecipes = widget.initialRecipes!;
    }
    _searchController.addListener(_searchListener);
    // The listener will be added in the build method where BlocProvider is available
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

  void _onSearchChanged(BuildContext context) {
    context.read<SearchBloc>().add(
      SearchQueryChanged(_searchController.text.trim()),
    );
  }

  Future<void> _loadToken() async {
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();
    if (mounted) {
      setState(() {
        _token = token;
      });
      _logger.d("Token: $_token");
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InternetConnectionWrapper(
        onReconnect: () {
          final query = _searchController.text.trim();
          if (query.isNotEmpty) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          }
        },
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
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 360,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _onSearchChanged(context),
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          fillColor: const Color(0xfff1f1f1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'البحث بالاسم، أو المكونات، أو الفئة',
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xffb2b2b2),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            decorationThickness: 6,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged(context);
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_searchController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _searchController.text,
                        style: TextStyle(
                          color: AppColors.perpel,
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.063,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const Divider(
                        height: 5, // Defines the empty space around the divider
                        thickness: 2, // Defines the thickness of the line
                        color: AppColors.perpel,
                        indent: 1, // Indent from the start of the line
                        endIndent: 1, // Indent from the end of the line
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SearchLoadFailure) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    if (state is SearchLoadSuccess) {
                      return _buildResultsList(state); // Pass the whole state
                    }
                    // Initial state or if search is empty
                    return _buildResultsList(
                      SearchLoadSuccess(
                        recipes: _initialRecipes,
                        currentPage: 0,
                        totalPages: 0,
                        totalItems: 0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(SearchLoadSuccess state) {
    final recipes = state.recipes;
    if (recipes.isEmpty) {
      return Center(
        child: Text(
          'لم يتم العثور على وصفات.',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    return Column(
      children: [
        FoodListViewHor(
          foodItems: recipes
              .map(
                (recipe) => FoodItem(
                  id: recipe.id ?? 0,
                  image: recipe.imgPath ?? 'https://via.placeholder.com/150',
                  title: recipe.title ?? 'No Title',
                  calories: recipe.kcal ?? 0,
                  duration: recipe.totalTime ?? 0,
                ),
              )
              .toList(),
          onItemTap: (itemId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(recipeId: itemId),
              ),
            );
          },
        ),
        if (!state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _buildLoadMoreButton(context),
          ),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<SearchBloc>().add(LoadMoreSearchResults());
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
}
