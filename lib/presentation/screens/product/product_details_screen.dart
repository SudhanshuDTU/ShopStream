import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/product/product_model.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/services/formatter.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/primary_Button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({super.key, required this.productModel});

  static const routeName = 'product_details';
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.productModel.title}"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
              itemCount: widget.productModel.images?.length ?? 0,
              slideBuilder: (index) {
                return CachedNetworkImage(
                    imageUrl: widget.productModel.images![index]);
              },
            ),
          ),
          GapWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productModel.title.toString(),
                  style: TextStyles.heading3,
                ),
                Text(
                    "₹${Formatter.formatPrice(widget.productModel.price!.toDouble())}",
                    style: TextStyles.heading2),
                GapWidget(
                  height: 10,
                ),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return PrimaryButton(
                        buttonText: BlocProvider.of<CartCubit>(context)
                                .cartContains(widget.productModel)
                            ? 'Product Added to Cart'
                            : 'Add to Cart',
                        onpress: () {
                          if (BlocProvider.of<CartCubit>(context)
                              .cartContains(widget.productModel)) {
                            return;
                          }
                          BlocProvider.of<CartCubit>(context)
                              .addToCart(widget.productModel, 1);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Product Added to Cart!",
                            ),
                            backgroundColor: Colors.green,
                          ));
                        },
                        buttonColor: BlocProvider.of<CartCubit>(context)
                                .cartContains(widget.productModel)
                            ? Colors.blueGrey
                            : Colors.redAccent);
                  },
                ),
                GapWidget(
                  height: 10,
                ),
                Text(
                  "Description :",
                  style: TextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.productModel.description.toString(),
                  style: TextStyles.body1,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
