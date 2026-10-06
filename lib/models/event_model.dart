import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventModel{
  String ownerId;
  String id;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime;

  EventModel({required this.ownerId,required this.id,required this.category, required this.title, required this.description, required this.dateTime});
  EventModel.fromJson(Map<String, dynamic> json): this (
    ownerId: json['ownerId'],
    id: json['id'],
    category : CategoryModel.categories.firstWhere((category) => category.id == json['categoryId']),
    title: json['title'],
    description: json['description'],
    dateTime: DateTime.parse(json['dateTime']),
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