import 'package:diety/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodListViewHor extends StatefulWidget {
  @override
  _FoodListViewHorState createState() => _FoodListViewHorState();
}

class _FoodListViewHorState extends State<FoodListViewHor>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;

  final List<FoodItem> foodItems = [
    FoodItem(
      image: 'assets/images/food1.webp',
      title: 'بروشيتا الكفتة والبطاطا',
      calories: 40,
      duration: 'دق',
    ),
    FoodItem(
      image: 'assets/images/food2.webp',
      title: 'سلطة الخضار المشكلة',
      calories: 25,
      duration: 'دق',
    ),
    FoodItem(
      image: 'assets/images/food3.webp',
      title: 'شوربة العدس الأحمر',
      calories: 35,
      duration: 'دق',
    ),
    FoodItem(
      image: 'assets/images/food1.webp',
      title: 'معكرونة بالصلصة الحمراء',
      calories: 55,
      duration: 'دق',
    ),
    FoodItem(
      image: 'assets/images/food2.webp',
      title: 'دجاج مشوي بالخضار',
      calories: 65,
      duration: 'دق',
    ),
  ];
  @override
  void initState() {
    super.initState();
    // Initialize the controller here
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // Dispose of the controller to free up resources
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            height: 330.0,
            margin: const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 25.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 18.0,
                ),
              ],
            ),
            child: FoodCard(foodItem: foodItems[index]),
          );
        },
      ),
    );
  }
}

class FoodCard extends StatefulWidget {
  final FoodItem foodItem;

  const FoodCard({Key? key, required this.foodItem}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(widget.foodItem.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Calories
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/flame.png",
                              width: 15,
                              height: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kcal',
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: AppColors.timecard,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${widget.foodItem.calories}',
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: AppColors.timecard,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(width: 2),
                          ],
                        ),
                        SizedBox(width: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: 0.75,
                              child: Icon(
                                Icons.access_time,
                                size: 15,
                                color: AppColors.timecard,
                              ),
                            ),
                            SizedBox(width: 4),
                            Opacity(
                              opacity: 0.75,
                              child: Text(
                                '${widget.foodItem.calories} ${widget.foodItem.duration}',
                                style: GoogleFonts.tajawal(
                                  fontSize: 16,
                                  color: AppColors.timecard,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Title
                    Text(
                      widget.foodItem.title,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titlecard,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 180,
          left: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavorite ? AppColors.favcard : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_border,
                color: isFavorite ? Colors.white : AppColors.favcard,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FoodItem {
  final String image;
  final String title;
  final int calories;
  final String duration;

  FoodItem({
    required this.image,
    required this.title,
    required this.calories,
    required this.duration,
  });
}
