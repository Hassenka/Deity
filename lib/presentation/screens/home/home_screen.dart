import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:diety/data/models/topic_model.dart';
import 'package:diety/logic/product_bloc/type_home_bloc/type_repas_bloc.dart';
import 'package:diety/logic/product_bloc/home_topic_bloc/topic_bloc.dart';
import 'package:diety/presentation/widgets/internet_connection_wrapper.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:diety/presentation/screens/categorie/categorie_screen.dart';
import 'package:diety/logic/product_bloc/random_home_bloc/random_recipes_bloc.dart';
import 'package:diety/presentation/screens/search/filter_screen.dart';
import 'package:diety/presentation/widgets/calorie_selection_screen.dart';
import 'package:diety/presentation/widgets/list_product.dart';
import 'package:diety/presentation/widgets/list_product_simple.dart'
    hide FoodCard;
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diety/presentation/widgets/calorie_selection_screen.dart'
    as calorie_widget;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<calorie_widget.CalorieData> CalorieItems1 = const [
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Cherries.webp',
      calorieRange: '50-0',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Watermelon.webp',
      calorieRange: '100-50',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Sandwich.webp',
      calorieRange: '200-100',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Bagel.webp',
      calorieRange: '300-200',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Stuffed.webp',
      calorieRange: '400-300',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Shallow.webp',
      calorieRange: '500-400',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Pot.webp',
      calorieRange: '600-500',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Spaghetti.webp',
      calorieRange: '700-600',
      check: true,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Hamburger.webp',
      calorieRange: '+700',
      check: true,
    ),
  ];
  final List<calorie_widget.CalorieData> CalorieItems2 = const [
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Broccoli.png',
      calorieRange: 'بالخضرة',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Cutofmeat.png',
      calorieRange: 'بالحم',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Tropicalfish.png',
      calorieRange: 'بالحوت',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Bread.png',
      calorieRange: 'بالعجينة',
      check: false,
    ),
  ];
  final List<calorie_widget.CalorieData> CalorieItems3 = const [
    calorie_widget.CalorieData(
      imagePath: 'assets/images/OkHand.webp',

      calorieRange: 'ساهلة',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Toolbox.png',
      calorieRange: 'نهزها معايا',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/PinchingHand.webp',
      calorieRange: 'شوية مكونات',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Greensalad.png',
      calorieRange: 'من غير تطييب ',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Stopwatch.png',
      calorieRange: 'فيسع فيسع',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Pie.png',
      calorieRange: 'في الفور',
      check: false,
    ),
  ];
  final List<calorie_widget.CalorieData> CalorieItems4 = const [
    calorie_widget.CalorieData(
      imagePath: 'assets/images/GreenApple.webp',
      calorieRange: 'قليل السعرات',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/LeafyGreen.webp',
      calorieRange: 'منخفض الدهون',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Peanuts.webp',
      calorieRange: 'منخفض الكربوهيدرات',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Cooking.webp',
      calorieRange: 'غني بالبروتين',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Eggplant.webp',
      calorieRange: 'غني بالألياف',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/sansSucre.webp',
      calorieRange: 'بدون سكر',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/sansLactose.webp',
      calorieRange: 'بدون لاكتوز',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/sansGluten.webp',
      calorieRange: 'بدون غلوتين',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Teacup.webp',
      calorieRange: 'دي توكس',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/PoultryLeg.webp',
      calorieRange: 'كيتو',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Fish.webp',
      calorieRange: 'بيكستر',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/CheeseWedge.webp',
      calorieRange: 'نباتي',
      check: false,
    ),
    calorie_widget.CalorieData(
      imagePath: 'assets/images/Shamrock.webp',
      calorieRange: 'نباتي صارم',
      check: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TopicBloc()..add(FetchTopics())),
        BlocProvider(
          create: (context) => TypeRepasBloc()..add(FetchTypeRepas()),
        ),
        BlocProvider(
          create: (context) => RandomRecipesBloc()..add(FetchRandomRecipes()),
        ),
      ],
      child: InternetConnectionWrapper(
        onReconnect: () {
          // Use a context that is a descendant of MultiBlocProvider
          final scaffoldContext = _scaffoldKey.currentContext;
          if (scaffoldContext != null) {
            scaffoldContext.read<TopicBloc>().add(FetchTopics());
            scaffoldContext.read<TypeRepasBloc>().add(FetchTypeRepas());
            scaffoldContext.read<RandomRecipesBloc>().add(FetchRandomRecipes());
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
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
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
              child: Wrap(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 0.0,
                        bottom: 8,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                horizontal: 6,
                                vertical: 1,
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
                                      SizedBox(width: 4), // mr-2 spacing
                                      Text(
                                        "وجبتك على كيفك",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontFamily:
                                              GoogleFonts.tajawal().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.053,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDynamicTopicSections(),
                          //const SizedBox(height: 20),
                          Text(
                            "اختار وجبتك",
                            style: TextStyle(
                              color: AppColors.perpel,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.063,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          Divider(
                            height: 5,
                            thickness: 2, // Defines the thickness of the line
                            color: AppColors.perpel,
                            indent: 1, // Indent from the start of the line
                            endIndent: 1, // Indent from the end of the line
                          ),
                          SizedBox(height: 20),
                          _buildTypeRepasSection(),
                          const SizedBox(height: 20),

                          Text(
                            "وصفات حسب المكونات",
                            style: TextStyle(
                              color: AppColors.perpel,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.063,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          Divider(
                            height: 5,
                            thickness: 2, // Defines the thickness of the line
                            color: AppColors.perpel,
                            indent: 1, // Indent from the start of the line
                            endIndent: 1, // Indent from the end of the line
                          ),
                          SizedBox(height: 20),
                          CalorieSelectionScreen(items: CalorieItems2),
                          const SizedBox(height: 40),
                          Text(
                            "وصفات حسب طريقة التحضير",
                            style: TextStyle(
                              color: AppColors.perpel,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.063,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          Divider(
                            height: 5,
                            thickness: 2, // Defines the thickness of the line
                            color: AppColors.perpel,
                            indent: 1, // Indent from the start of the line
                            endIndent: 1, // Indent from the end of the line
                          ),
                          SizedBox(height: 20),
                          CalorieSelectionScreen(items: CalorieItems3),
                          const SizedBox(height: 40),
                          Text(
                            "وصفات حسب النظام الغذائي",
                            style: TextStyle(
                              color: AppColors.perpel,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.063,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          Divider(
                            height: 5,
                            thickness: 2, // Defines the thickness of the line
                            color: AppColors.perpel,
                            indent: 1, // Indent from the start of the line
                            endIndent: 1, // Indent from the end of the line
                          ),
                          SizedBox(height: 20),
                          CalorieSelectionScreen(items: CalorieItems4),
                          const SizedBox(height: 40),
                          _buildRandomRecipesSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicTopicSections() {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is TopicLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TopicLoadFailure) {
          return Center(child: Text('Failed to load topics: ${state.error}'));
        }
        if (state is TopicLoadSuccess) {
          final topics = state.topics;
          if (topics.isEmpty) {
            return const SizedBox.shrink();
          }

          final topicWidgets = <Widget>[];

          // Topic 0
          if (topics.isNotEmpty) {
            topicWidgets.add(_buildTopicWidget(context, topics[0]));
          }

          // Topic 1
          if (topics.length > 1) {
            topicWidgets.add(_buildTopicWidget(context, topics[1]));
          }

          // Calorie Section
          topicWidgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                  height: 5,
                  thickness: 2,
                  color: AppColors.perpel,
                  indent: 1,
                  endIndent: 1,
                ),
                const SizedBox(height: 20),
                CalorieSelectionScreen(items: CalorieItems1),
                const SizedBox(height: 20),
              ],
            ),
          );

          // The rest of the topics
          if (topics.length > 2) {
            topicWidgets.addAll(
              topics
                  .sublist(2)
                  .map((topic) => _buildTopicWidget(context, topic)),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: topicWidgets,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTopicWidget(BuildContext context, Topic topic) {
    if (topic.recipe == null || topic.recipe!.isEmpty) {
      return const SizedBox.shrink();
    }

    final foodItems = topic.recipe!.map((recipe) {
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
        const SizedBox(height: 10),
        Text(
          topic.title ?? 'No Title',
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
        _buildFoodListView(foodItems),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFoodListView(List<FoodItem> foodItems) {
    // This is a simplified version of your FoodListView.
    // We create a new instance here to pass the dynamic data.
    return Container(
      // Changed from SizedBox to Container for more flexibility
      height:
          450, // Adjusted height, consider making this dynamic based on FoodCard content
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(recipeId: foodItems[index].id),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8 - 16,
              margin: const EdgeInsets.only(top: 6.0, bottom: 16.0, left: 25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: FoodCard(foodItem: foodItems[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeRepasSection() {
    return BlocBuilder<TypeRepasBloc, TypeRepasState>(
      builder: (context, state) {
        if (state is TypeRepasLoadInProgress) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TypeRepasLoadFailure) {
          return Center(
            child: Text('Failed to load meal types: ${state.error}'),
          );
        }
        if (state is TypeRepasLoadSuccess) {
          final foodItems = state.typeRepasItems.map((item) {
            return FoodItemSimple(image: item.image, title: item.title);
          }).toList();

          return FoodListViewsim(
            foodItems: foodItems,
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategorieScreen(categoryName: item.title),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRandomRecipesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const Divider(
          height: 5,
          thickness: 2,
          color: AppColors.perpel,
          indent: 1,
          endIndent: 1,
        ),
        const SizedBox(height: 20),
        BlocBuilder<RandomRecipesBloc, RandomRecipesState>(
          builder: (context, state) {
            if (state is RandomRecipesLoadInProgress) {
              return const SizedBox(
                height: 470,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is RandomRecipesLoadFailure) {
              return Center(
                child: Text('Failed to load recipes: ${state.error}'),
              );
            }
            if (state is RandomRecipesLoadSuccess) {
              final foodItems = state.recipes.map((recipe) {
                return FoodItem(
                  id: recipe.id ?? 0,
                  image: recipe.imgPath ?? 'https://via.placeholder.com/150',
                  title: recipe.title ?? 'No Title',
                  calories: recipe.kcal ?? 0,
                  duration: recipe.totalTime ?? 0,
                );
              }).toList();
              return _buildFoodListView(foodItems);
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
