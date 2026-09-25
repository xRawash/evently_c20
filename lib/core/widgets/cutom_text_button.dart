import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
   CustomTextButton({super.key, required this.text, required this.onTap, this.textAlign = TextAlign.start});
  String text;
  VoidCallback onTap;
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:onTap ,
        child: Text(text, textAlign: textAlign,style: Theme.of(context).textTheme.bodyMedium,));
  }
}
