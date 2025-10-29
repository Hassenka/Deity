import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class FoodListView extends StatefulWidget {
  @override
  _FoodListViewState createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late Timer _timer;
  bool _isScrollingForward = true;
  double _cardWidth = 296.0; // 280 + 16 margin

  final List<FoodItem> foodItems = [
    FoodItem(
      image: 'assets/images/food1.webp',
      title: 'بروشيتا الكفتة والبطاطا',
      calories: 40,
      duration: 15,
      id: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_scrollController.hasClients) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentPosition = _scrollController.offset;

        if (_isScrollingForward) {
          if (currentPosition >= maxScrollExtent) {
            _isScrollingForward = false;
            _animateToPosition(maxScrollExtent - _cardWidth);
          } else {
            _animateToPosition(currentPosition + _cardWidth);
          }
        } else {
          if (currentPosition <= 0) {
            _isScrollingForward = true;
            _animateToPosition(_cardWidth);
          } else {
            _animateToPosition(currentPosition - _cardWidth);
          }
        }
      }
    });
  }

  void _animateToPosition(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 3),
      curve: Curves.easeInOut,
    );
  }

  void _pauseAutoScroll() {
    _timer.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 470,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollStartNotification) {
              if (notification.dragDetails != null) {
                _pauseAutoScroll();
              }
            } else if (notification is ScrollEndNotification) {
              if (notification.dragDetails != null) {
                // Resume auto-scroll after user stops scrolling
                Future.delayed(Duration(seconds: 2), () {
                  if (mounted) {
                    _resumeAutoScroll();
                  }
                });
              }
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8 - 16,
                margin: const EdgeInsets.only(
                  top: 6.0,
                  bottom: 16.0,
                  left: 25.0,
                ),
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
              );
            },
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesManager>(
      builder: (context, favoritesManager, child) {
        final bool isFavorite = favoritesManager.isFavorite(widget.foodItem.id);
        return Stack(
          children: [
            ClipRRect(
              // This ensures the image has rounded top corners
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.foodItem.image,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                  ),
                ),
                width: double.infinity,
                height: 330,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            Positioned(
              top: 336,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 9,
                      bottom: 9,
                      right: 25,
                      left: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Calories
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Image.asset(
                                    "assets/images/flame.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Kcal',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 16,
                                      color: AppColors.timecard,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${widget.foodItem.calories}',
                                  style: GoogleFonts.tajawal(
                                    fontSize: 20,
                                    color: AppColors.timecard,
                                    //fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 2),
                              ],
                            ),
                            SizedBox(width: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.0),
                                  child: Opacity(
                                    opacity: 0.75,
                                    child: Icon(
                                      Icons.access_time,
                                      size: 15,
                                      color: AppColors.timecard,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Opacity(
                                  opacity: 0.75,
                                  child: Text(
                                    "${widget.foodItem.duration} دق",
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

                        SizedBox(height: 5),

                        // Title
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8 - 54,
                          height: 45,
                          child: Text(
                            widget.foodItem.title,
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              //fontWeight: FontWeight.bold,
                              color: AppColors.titlecard,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 310,
              left: 12,
              child: GestureDetector(
                onTap: () => favoritesManager.toggleFavorite(
                  widget.foodItem.id,
                  context: context,
                ),
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
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.white : AppColors.favcard,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
