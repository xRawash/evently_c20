import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
   CustomTextFormField({required this.hintText, this.prefixIcon,this.isObscured = false ,this.suffixIcon,  this.controller,  this.validator, this.lines = 1});
  String hintText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextEditingController? controller;
String? Function(String?)? validator;
bool isObscured;
int lines ;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscured = false;
  @override
  void initState() {

    super.initState();
    isObscured = widget.isObscured;
  }
  Widget obscureIcon () {
    return IconButton(
      onPressed: () {
        setState(() {
          isObscured = !isObscured;
        });
      },
      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
    );
  }
  @override
  Widget build(BuildContext context) {
    return    TextFormField(
      maxLines: widget.lines,
      obscureText: isObscured,
      obscuringCharacter: '*',
      validator:widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(

          prefixIcon:widget.prefixIcon,
          suffixIcon: widget.isObscured? obscureIcon() : widget.suffixIcon,
          hintText: widget.hintText
      ),
    );
  }
}
