// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontend/core/ui.dart';

class LinkButton extends StatelessWidget {
  String buttonText;
  VoidCallback onpress;
  Color TextColor;
  LinkButton({
    Key? key,
    required this.buttonText,
    required this.onpress,
    required this.TextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onPressed: onpress,
      child: Text(
        buttonText,
        style: TextStyles.body1.copyWith(fontSize: 18, color: Colors.teal),
      ),
    );
  }
}
