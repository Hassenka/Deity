import 'package:diety/data/repositories/api_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  int _unreadCount = 0;
  final ApiService _apiService = ApiService();

  int get unreadCount => _unreadCount;

  Future<void> fetchNotificationCount() async {
    try {
      final notifications = await _apiService.getNotifications();
      _unreadCount = notifications.where((n) => n.isRead == false).length;
      notifyListeners();
    } catch (e) {
      // Handle error, maybe log it
      print("Failed to fetch notification count: $e");
      _unreadCount = 0; // Reset on error
      notifyListeners();
    }
  }
}
