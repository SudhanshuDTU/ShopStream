import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({super.key});
  static const routeName = 'orderPlaced';
  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed!"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.cube_box_fill,
            color: AppColors.textLight,
            size: 100,
          ),
          Text(
            "Order Placed!",
            style: TextStyles.heading3.copyWith(color: AppColors.textLight),
          ),
          GapWidget(
            height: 8,
          ),
          Text(
            "You can Check out the Status by going to Profile > My Orders",
            style: TextStyles.body2.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
