import 'package:diety/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

// Assuming AppColors is defined like this.

class FoodListViewsim extends StatefulWidget {
  @override
  _FoodListViewsimState createState() => _FoodListViewsimState();
}

class _FoodListViewsimState extends State<FoodListViewsim>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late Timer _timer;
  bool _isScrollingForward = true;
  final double _cardWidth = 296.0;

  final List<FoodItem> foodItems = [
    FoodItem(image: 'assets/images/food1.webp', title: "فطور الصباح"),
    FoodItem(image: 'assets/images/food2.webp', title: 'ديسار'),
    FoodItem(image: 'assets/images/food3.webp', title: 'شوربة'), 
    FoodItem(image: 'assets/images/food2.webp', title: 'عشاء'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_scrollController.hasClients) return;

      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double currentPosition = _scrollController.offset;
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure there's enough content to scroll
      if (maxScrollExtent <= screenWidth) return;

      if (_isScrollingForward) {
        // If we are at or near the end
        if (currentPosition >= maxScrollExtent - 1.0) {
          _isScrollingForward = false;
          _animateToPosition(currentPosition - _cardWidth);
        } else {
          // Move forward
          double nextPosition = currentPosition + _cardWidth;
          _animateToPosition(
            nextPosition > maxScrollExtent ? maxScrollExtent : nextPosition,
          );
        }
      } else {
        // If we are at or near the beginning
        if (currentPosition <= 0) {
          _isScrollingForward = true;
          _animateToPosition(_cardWidth);
        } else {
          // Move backward
          double nextPosition = currentPosition - _cardWidth;
          _animateToPosition(nextPosition < 0 ? 0 : nextPosition);
        }
      }
    });
  }

  void _animateToPosition(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(seconds: 1),
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
    return SizedBox(
      height: 320,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // Pause on manual scroll
          if (notification is ScrollStartNotification &&
              notification.dragDetails != null) {
            _pauseAutoScroll();
          }
          // Resume after manual scroll ends
          else if (notification is ScrollEndNotification) {
            _resumeAutoScroll();
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: Offset(0, 1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: FoodCard(foodItem: foodItems[index]),
            );
          },
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
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ClipRRect ensures the image has rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                widget.foodItem.image,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              Container(
                height: 100.0,
                padding: const EdgeInsets.only(top: 30, right: 10),
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border(
                    right: BorderSide(
                      color: Color(0xFF007AFF), // Blue accent color
                      width: 8,
                    ),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 123.0),
                  child: Text(
                    widget.foodItem.title,
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF262F82), // Dark blue text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Favorite Button - Positioned over the card
        Positioned(
          top: 180, // Adjusted for better placement
          left: 16,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavorite ? AppColors.favcard : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.white : AppColors.favcard,
                size: 24,
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

  FoodItem({required this.image, required this.title});
}
