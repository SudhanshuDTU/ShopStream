// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontend/core/ui.dart';

class PrimaryButton extends StatelessWidget {
  String buttonText;
  VoidCallback onpress;
  Color buttonColor;
  PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.onpress,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CupertinoButton(
        onPressed: onpress,
        color: buttonColor,
        child: Text(
          buttonText,
          style: TextStyles.buttonstyle,
        ),
      ),
    );
  }
}
