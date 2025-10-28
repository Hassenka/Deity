import 'package:intl/intl.dart';

class NotificationModel {
  String? id;
  String? title;
  String? message;
  String? img;
  int? totalTime;
  int? elementId;
  String? userType;
  String? createdAt;
  bool? isRead;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.img,
    this.totalTime,
    this.elementId,
    this.userType,
    this.createdAt,
    this.isRead,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    img = json['img'];
    totalTime = json['total_time'];
    elementId = json['elementId'];
    userType = json['userType'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['img'] = this.img;
    data['total_time'] = this.totalTime;
    data['elementId'] = this.elementId;
    data['userType'] = this.userType;
    data['createdAt'] = this.createdAt;
    data['isRead'] = this.isRead;
    return data;
  }

  // Helper getters for date formatting
  DateTime? get _createdAtDateTime {
    if (createdAt == null) return null;
    try {
      // Assuming createdAt is UTC and converting to local time
      return DateTime.parse(createdAt!).toLocal();
    } catch (e) {
      // Log the error for debugging
      print('Error parsing createdAt date: $e');
      return null;
    }
  }

  String get formattedDate {
    if (_createdAtDateTime == null) return '';
    return DateFormat('dd/MM/yyyy').format(_createdAtDateTime!);
  }

  String get timeAgo {
    if (_createdAtDateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(_createdAtDateTime!);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة مضت';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر مضت';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} أسبوع مضت';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم مضت';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة مضت';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة مضت';
    } else {
      return 'الآن';
    }
  }
}
