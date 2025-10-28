import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

// Assuming AppColors is defined like this.

class FoodListViewsim extends StatefulWidget {
  final List<FoodItemSimple> foodItems;
  final Function(FoodItemSimple item)? onItemTap;

  const FoodListViewsim({super.key, this.foodItems = const [], this.onItemTap});
  @override
  _FoodListViewsimState createState() => _FoodListViewsimState();
}

class _FoodListViewsimState extends State<FoodListViewsim>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late Timer _timer;
  bool _isScrollingForward = true;
  final double _cardWidth = 296.0;

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
      duration: const Duration(seconds: 5),
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
      height: 450,
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
          itemCount: widget.foodItems.length,
          itemBuilder: (context, index) {
            final item = widget.foodItems[index];
            return GestureDetector(
              onTap: () => widget.onItemTap?.call(item),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8 - 16,
                margin: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
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
                child: FoodCard(foodItemSimple: item),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FoodCard extends StatefulWidget {
  final FoodItemSimple foodItemSimple;

  const FoodCard({Key? key, required this.foodItemSimple}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ClipRRect ensures the image has rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CachedNetworkImage(
                imageUrl: widget.foodItemSimple.image,
                height: 330.0,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                  ),
                ),
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
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    widget.foodItemSimple.title,
                    style: GoogleFonts.tajawal(
                      fontSize: 25,
                      //fontWeight: FontWeight.bold,
                      color: const Color(0xFF262F82), // Dark blue text color
                    ),
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}

class FoodItemSimple {
  final String image;
  final String title;

  FoodItemSimple({required this.image, required this.title});
}
