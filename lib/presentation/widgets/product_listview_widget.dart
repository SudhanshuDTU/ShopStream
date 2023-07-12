import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/product/product_model.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/services/formatter.dart';
import 'package:frontend/presentation/screens/product/product_details_screen.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  const ProductListView({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                arguments: product);
          },
          child: Row(
            children: [
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.15,
                imageUrl: "${product.images?[0]}",
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title.toString(),
                      style: TextStyles.body1
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.description.toString(),
                      style:
                          TextStyles.body2.copyWith(color: AppColors.textLight),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    GapWidget(
                      height: 10,
                    ),
                    Text(
                      "₹ ${Formatter.formatPrice(product.price!.toDouble())}",
                      style: TextStyles.heading3,
                    )
                  ],
                ),
              ),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, cartstate) {
                  return IconButton(
                      onPressed: () {
                        if (BlocProvider.of<CartCubit>(context)
                            .cartContains(products[index])) {
                          return;
                        }
                        BlocProvider.of<CartCubit>(context)
                            .addToCart(products[index], 1);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Product Added to Cart!",
                          ),
                          backgroundColor: Colors.green,
                        ));
                      },
                      icon: BlocProvider.of<CartCubit>(context)
                              .cartContains(products[index])
                          ? const Icon(
                              Icons.done_rounded,
                              color: Colors.redAccent,
                            )
                          : const Icon(Icons.shopping_bag_outlined));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
