import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/logic/cubits/orderCubit/order_cubit.dart';
import 'package:frontend/logic/cubits/orderCubit/order_state.dart';
import 'package:frontend/logic/services/calculation.dart';
import 'package:frontend/logic/services/formatter.dart';
import 'package:frontend/logic/services/razorpay.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});
  static const routeName = "myOrders";
  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: GoogleFonts.robotoSlab(
              color: const Color.fromARGB(255, 196, 147, 2)),
        ),
      ),
      body: SafeArea(child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState && state.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrderErrorState && state.orders.isEmpty) {
            return Center(
              child: Text(state.message.toString()),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (context, index) {
              return Column(
                children: [
                  GapWidget(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.redAccent,
                  ),
                  GapWidget(
                    height: 10,
                  ),
                ],
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final order = state.orders[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "# - ${order.sId}",
                    style:
                        TextStyles.body2.copyWith(color: AppColors.textLight),
                  ),
                  Text(
                    "Order Placed on : ${Formatter.formatDate(order.createdOn!)}",
                    style: TextStyles.body2.copyWith(color: AppColors.accent),
                  ),
                  Text(
                    "Order Total : ₹${Formatter.formatPrice(Calculations.cartTotal(order.items!))}",
                    style:
                        TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items!.length,
                    itemBuilder: (context, index) {
                      final item = order.items![index];
                      final product = item.product!;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("${product.title}"),
                        subtitle: Text("${item.quantity}"),
                        leading: CachedNetworkImage(
                          imageUrl: product.images![0],
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        trailing: Text(
                          "₹${Formatter.formatPrice(product.price! * item.quantity!.toDouble())}",
                          style: TextStyles.body2
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  Text(
                    "Status: ${order.status}",
                    style:
                        TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              );
            },
          );
        },
      )),
    );
  }
}
