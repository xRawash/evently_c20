import 'package:evently_app_abbas/models/category_model.dart';

class EventModel{
  String ownerId;
  String id;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime;

  EventModel({required this.ownerId,required this.id,required this.category, required this.title, required this.description, required this.dateTime});
  EventModel.fromJson(Map<String, dynamic> json)
      : this(
          ownerId: json['ownerId'] ?? '',
          id: json['id'] ?? '',
          category: CategoryModel.categories.firstWhere(
            (category) => category.id == json['categoryId'],
            orElse: () => CategoryModel.categories.first,
          ),
          title: json['title'] ?? '',
          description: json['description'] ?? '',
          dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
        );

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'id': id,
      'categoryId': category.id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
}
}