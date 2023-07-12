import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  TextEditingController? controller;
  String labeltext;
  bool obsecure;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String)? onchanged;
  PrimaryTextField(
      {Key? key,
      this.controller,
      required this.labeltext,
      this.initialValue,
      this.onchanged,
      this.obsecure = false,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecure,
      initialValue: initialValue,
      onChanged: onchanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: labeltext,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}
