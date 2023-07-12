import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/services/calculation.dart';
import 'package:frontend/logic/services/formatter.dart';
import 'package:frontend/presentation/screens/order/orderDetail_screen.dart';
import 'package:frontend/presentation/widgets/cart_listview.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = 'cart';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Cart",
        style: GoogleFonts.fjallaOne(
            color: Colors.indigo,
            fontSize: MediaQuery.of(context).size.height * 0.03),
      )),
      body: SafeArea(child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState && state.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          }
          if (state is CartErrorState && state.items.isEmpty) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is CartLoadedState && state.items.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/2762/2762885.png',
                  fit: BoxFit.contain,
                ),
                Text(
                  "Your Cart is Empty..",
                  style: TextStyles.heading3,
                )
              ],
            );
          }

          return Column(
            children: [
              Expanded(child: CartListView(items: state.items)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${state.items.length} items",
                          style: TextStyles.body1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "Total : ₹${Formatter.formatPrice(Calculations.cartTotal(state.items))}",
                            style: TextStyles.heading3)
                      ],
                    )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 22),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, OrderDetailScreen.routeName);
                        },
                        color: Colors.teal,
                        child: const Text("Place Order"),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
