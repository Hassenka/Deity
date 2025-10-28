class TypeRepasItem {
  final int id;
  final String title;
  final String status;
  final String image;
  final int order;

  TypeRepasItem({
    required this.id,
    required this.title,
    required this.status,
    required this.image,
    required this.order,
  });

  factory TypeRepasItem.fromJson(Map<String, dynamic> json) {
    return TypeRepasItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      image: json['image'] ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }

  static List<TypeRepasItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TypeRepasItem.fromJson(json)).toList();
  }
}
