import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/data/models/notification_model.dart';
import 'package:diety/data/repositories/notification_provider.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/presentation/widgets/right_side_drawer.dart';
import 'package:diety/presentation/widgets/gradient_snackbar.dart';
import 'package:diety/presentation/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

// --- The Main Notification Screen Widget ---
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<NotificationModel>> _notificationsFuture;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notificationsFuture = _apiService.getNotifications();
    });
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead == true) return;

    try {
      await _apiService.markNotificationAsRead(notification.id!);
      // Optionally, refresh the list or update the item's state locally
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchNotificationCount();
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          elevation: 0,
          content: GradientSnackBarContent(
            message: 'Failed to mark as read: $e',
          ),
        ),
      );
    }
  }

  // Function to handle the deletion of an item
  void _deleteItem(int index) async {
    final notification = _notifications[index];
    try {
      await _apiService.deleteNotification(notification.id!);
      setState(() {
        Provider.of<NotificationProvider>(
          context,
          listen: false,
        ).fetchNotificationCount();
        _notifications.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          elevation: 0,
          content: GradientSnackBarContent(message: 'تم الحذف بنجاح!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          elevation: 0,
          content: GradientSnackBarContent(
            message: 'Failed to delete notification: $e',
          ),
        ),
      );
    }
  }

  // Function to handle saving an item
  void _saveItem(int index) async {
    final notification = _notifications[index];
    if (notification.elementId != null) {
      try {
        await _apiService.saveRecipe(notification.elementId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            elevation: 0,
            content: GradientSnackBarContent(
              message: 'تم حفظ الوصفة بنجاح!',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            elevation: 0,
            content: GradientSnackBarContent(
              message: 'فشل حفظ الوصفة: $e',
              icon: Icons.remove_circle_outline,
              iconColor: Colors.red,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          elevation: 0,
          content: GradientSnackBarContent(
            message: 'لا توجد وصفة مرتبطة بهذا الإشعار.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onNotificationTapped(NotificationModel notification) {
    // First, mark the notification as read to update its state and the badge count.
    _markAsRead(notification);

    // Then, if there's a recipe associated with it, navigate to the detail screen.
    if (notification.elementId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (newContext) => ChangeNotifierProvider.value(
            value: context
                .read<FavoritesManager>(), // Pass the existing instance
            child: DetailScreen(recipeId: notification.elementId!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Directionality(
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
                    SizedBox(height: MediaQuery.of(context).size.height * .004),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle below the AppBar

            // The list of notifications
            Expanded(
              child: FutureBuilder<List<NotificationModel>>(
                future: _notificationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('لا توجد إشعارات'));
                  }

                  _notifications = snapshot.data!;
                  final unreadCount = _notifications
                      .where((n) => n.isRead != true)
                      .length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: Text(
                          '$unreadCount إشعارات تنتظركم !',
                          style: TextStyle(
                            color: AppColors.perpel,
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.063,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 32.0, right: 32),
                        child: Divider(color: AppColors.perpel, thickness: 2),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final item = _notifications[index];
                            return GestureDetector(
                              onTap: () => _onNotificationTapped(item),
                              child: Slidable(
                                key: ValueKey(
                                  item.id,
                                ), // Unique key for each item
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    CustomSlidableAction(
                                      onPressed: (context) =>
                                          _deleteItem(index),
                                      backgroundColor: const Color(0xFFFE4A49),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/del.png',
                                            //poubelle.png', // Assumed asset path
                                            color: Colors.white,
                                            // width: 24,
                                            // height: 24,
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'حذف',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (item.id != null)
                                      CustomSlidableAction(
                                        onPressed: (context) =>
                                            _saveItem(index),
                                        backgroundColor: const Color(
                                          0xFF0392CF,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/fav.png',

                                              //bookmark.png', // Assumed asset path
                                              color: Colors.white,
                                              // width: 24,
                                              // height: 24,
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'حفظ',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                child: _buildNotificationCard(item),
                              ),
                            );
                          },
                        ), // This closing parenthesis is for the Expanded above
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadNotifications,
          child: const Icon(Icons.refresh, color: Colors.white),
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }

  // --- Widget for building a single notification card ---
  Widget _buildNotificationCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.isRead == true
            ? Colors.white
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image on the left (in RTL)
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.img != null
                      ? Image.network(
                          item.img!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: Icon(Icons.notifications, color: Colors.grey),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // Text content on the right (in RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.timeAgo, // Now available via getter
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    if (item.isRead != true)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.title ?? '',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlecard,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.message ?? '', // Use message property
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item.formattedDate, // Now available via getter
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
