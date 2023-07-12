import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/logic/cubits/productCubit/product_cubit.dart';
import 'package:frontend/logic/cubits/productCubit/product_state.dart';
import 'package:frontend/presentation/widgets/product_listview_widget.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoadingState && state.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          );
        } else if (state is ProductErrorState && state.products.isEmpty) {
          return Center(
            child: Text(state.message.toString()),
          );
        }
        return ProductListView(products: state.products);
      },
    );
  }
}
