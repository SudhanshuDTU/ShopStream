import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/cart/cart_item_model.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/services/formatter.dart';
import 'package:frontend/presentation/widgets/link_button.dart';

class CartListView extends StatefulWidget {
  final List<CartItemModel> items;
  final bool shrinkWrap;
  final bool noScroll;
  const CartListView({
    Key? key,
    this.shrinkWrap = false,
    this.noScroll = false,
    required this.items,
  }) : super(key: key);

  @override
  State<CartListView> createState() => _CartListViewState();
}

class _CartListViewState extends State<CartListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: widget.noScroll ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return ListTile(
          leading: CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.contain,
            imageUrl: item.product!.images![0],
          ),
          title: Text(
            "${item.product?.title}",
            style: TextStyles.heading3
                .copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "₹${Formatter.formatPrice(item.product!.price!.toDouble())} x ${item.quantity} = ${Formatter.formatPrice(item.product!.price!.toDouble() * item.quantity!)}"),
              LinkButton(
                  buttonText: 'Delete',
                  onpress: () {
                    BlocProvider.of<CartCubit>(context)
                        .removeFromCart(item.product!);
                  },
                  TextColor: const Color.fromARGB(255, 22, 103, 169))
            ],
          ),
          trailing: InputQty(
            minVal: 1,
            initVal: item.quantity!, //Product initial quantity
            maxVal: 99,
            showMessageLimit: false,
            steps: 1,
            onQtyChanged: (value) {
              if (value == item.quantity) {
                return;
              }
              BlocProvider.of<CartCubit>(context)
                  .addToCart(item.product!, value as int);
            },
          ),
        );
      },
    );
  }
}
