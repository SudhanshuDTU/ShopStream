// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class GapWidget extends StatelessWidget {
  double height;
  double width;
  GapWidget({
    Key? key,
    this.height = 16,
    this.width = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
