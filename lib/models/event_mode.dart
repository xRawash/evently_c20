import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/material.dart';

class EventModel{
  int id;
  CategoryModel category;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  EventModel({required this.id,required this.category, required this.title, required this.description, required this.date, required this.time});

}