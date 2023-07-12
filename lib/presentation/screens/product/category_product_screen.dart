import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/logic/cubits/categoryproductCubit/categoryProduct_cubit.dart';
import 'package:frontend/logic/cubits/categoryproductCubit/categoryProduct_state.dart';
import 'package:frontend/presentation/widgets/product_listview_widget.dart';

class CategoryProductScreen extends StatefulWidget {
  const CategoryProductScreen({super.key});
  static const routeName = 'categoryProduct';
  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CategoryProductCubit>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "${cubit.category.title}",
        style: TextStyles.body2.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 60, 152, 199)),
      )),
      body: SafeArea(
          child: BlocBuilder<CategoryProductCubit, CategoryProductState>(
        builder: (context, state) {
          if (state is CategoryProductInitialState && state.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            );
          }

          if (state is CategoryProductErrorState && state.products.isEmpty) {
            return Center(child: Text(state.message));
          }
          if (state is CategoryProductLoadedState && state.products.isEmpty) {
            return const Center(child: Text("No Product Found!"));
          }

          return ProductListView(products: state.products);
        },
      )),
    );
  }
}
