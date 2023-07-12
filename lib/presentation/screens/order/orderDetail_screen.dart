import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/order/order_model.dart';
import 'package:frontend/data/models/user/user_model.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/cubits/orderCubit/order_cubit.dart';
import 'package:frontend/logic/cubits/orderCubit/order_state.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/logic/services/razorpay.dart';
import 'package:frontend/presentation/screens/order/orderPlaced_screen.dart';
import 'package:frontend/presentation/screens/order/providers/orderDetailProvider.dart';
import 'package:frontend/presentation/screens/user/editProfile_screen.dart';
import 'package:frontend/presentation/widgets/cart_listview.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/link_button.dart';
import 'package:frontend/presentation/widgets/primary_Button.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});
  static const routeName = 'order_detail';
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "New Order",
        style: TextStyle(fontWeight: FontWeight.w600),
      )),
      body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              );
            }
            if (state is UserErrorState) {
              return Center(child: Text(state.message));
            }
            if (state is UserLoggedInState) {
              UserModel user = state.userModel;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Details",
                    style:
                        TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${user.fullName}",
                    style: TextStyles.heading3,
                  ),
                  Text(
                    "Email: ${user.email}",
                    style: TextStyles.body2,
                  ),
                  Text(
                    "Phone: ${user.phoneNumber}",
                    style: TextStyles.body2,
                  ),
                  Text(
                    "Address: ${user.address}, ${user.city}, ${user.state}",
                    style: TextStyles.body2,
                  ),
                  LinkButton(
                      buttonText: 'Edit Profile',
                      onpress: () {
                        Navigator.pushNamed(
                            context, EditProfileScreen.routeName);
                      },
                      TextColor: Colors.teal),
                ],
              );
            }
            return SizedBox();
          },
        ),
        GapWidget(
          height: 8,
        ),
        Text(
          "Items",
          style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
        ),
        GapWidget(
          height: 8,
        ),
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState && state.items.isEmpty) {
              return const CircularProgressIndicator();
            }
            if (state is CartErrorState && state.items.isEmpty) {
              return Text(state.message);
            }
            return CartListView(
              items: state.items,
              shrinkWrap: true,
              noScroll: true,
            );
          },
        ),
        GapWidget(
          height: 8,
        ),
        Text(
          "Payment",
          style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
        ),
        GapWidget(
          height: 8,
        ),
        Consumer<OrderDetailProvider>(builder: (context, provider, child) {
          return Column(
            children: [
              RadioListTile(
                value: "Pay-On-Delivery",
                groupValue: provider.paymentMethod,
                contentPadding: EdgeInsets.zero,
                onChanged: provider.changePaymentMethod,
                title: const Text("Pay-On-Delivery"),
              ),
              RadioListTile(
                value: "PayNow",
                groupValue: provider.paymentMethod,
                contentPadding: EdgeInsets.zero,
                onChanged: provider.changePaymentMethod,
                title: const Text("Pay Now"),
              ),
            ],
          );
        }),
        GapWidget(),
        PrimaryButton(
            buttonText: "Place Order",
            onpress: () async {
              OrderModel? newOrder = await BlocProvider.of<OrderCubit>(context)
                  .createOrder(
                      items: BlocProvider.of<CartCubit>(context).state.items,
                      paymentMethod: Provider.of<OrderDetailProvider>(context,
                              listen: false)
                          .paymentMethod
                          .toString());
              if (newOrder == null) {
                return;
              }
              if (newOrder.status == "Payment Pending") {
                //Payment activate krdo
                await RazorPayServices.checkoutOrder(newOrder,
                    onSuccess: (response) async {
                  newOrder.status = "Order Placed";
                  bool success = await BlocProvider.of<OrderCubit>(context)
                      .updateOrder(newOrder,
                          paymentId: response.paymentId,
                          signature: response.signature);
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Can't update the Order !",
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                }, onFailure: (response) {
                  log("payment failed");
                });
              }

              if (newOrder.status == "Order Placed") {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, OrderPlacedScreen.routeName);
              }
            },
            buttonColor: Colors.indigo)
      ])),
    );
  }
}
