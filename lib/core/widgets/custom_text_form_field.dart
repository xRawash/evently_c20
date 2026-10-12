import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.isObscured = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.lines = 1,
  });

  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isObscured;
  final int lines;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.isObscured;
  }

  Widget obscureIcon() {
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
    return TextFormField(
      maxLines: widget.lines,
      obscureText: isObscured,
      obscuringCharacter: '*',
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscured ? obscureIcon() : widget.suffixIcon,
        hintText: widget.hintText,
      ),
    );
  }
}
