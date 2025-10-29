import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/data/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

/// --- WIDGETS MODIFIED FOR VERTICAL LIST ---

class FoodListViewHor extends StatefulWidget {
  final List<FoodItem> foodItems;
  final Function(int id)? onItemTap;

  const FoodListViewHor({super.key, required this.foodItems, this.onItemTap});

  @override
  _FoodListViewHorState createState() => _FoodListViewHorState();
}

class _FoodListViewHorState extends State<FoodListViewHor> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.foodItems.length,
      itemBuilder: (context, index) {
        final item = widget.foodItems[index];
        return GestureDetector(
          onTap: () => widget.onItemTap?.call(item.id),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8 - 16,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: FoodCardHor(foodItem: item),
          ),
        );
      },
    );
  }
}

class FoodCardHor extends StatefulWidget {
  final FoodItem foodItem;
  const FoodCardHor({Key? key, required this.foodItem}) : super(key: key);

  @override
  _FoodCardHorState createState() => _FoodCardHorState();
}

class _FoodCardHorState extends State<FoodCardHor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesManager>(
      builder: (context, favoritesManager, child) {
        final bool isFavorite = favoritesManager.isFavorite(widget.foodItem.id);
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
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.foodItem.image,
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
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
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
                              width:
                                  MediaQuery.of(context).size.width * 0.8 - 54,
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
                  SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              top: 380,
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
