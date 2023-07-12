import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/logic/cubits/categoryCubit/category_cubit.dart';
import 'package:frontend/logic/cubits/categoryCubit/category_state.dart';
import 'package:frontend/presentation/screens/product/category_product_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState && state.categories.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.indigo,
          ));
        } else if (state is CategoryErrorState && state.categories.isEmpty) {
          return Center(
            child: Text(state.message.toString()),
          );
        }

        return ListView.builder(
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, CategoryProductScreen.routeName,
                    arguments: category);
              },
              leading: const Icon(Icons.category),
              title: Text("${category.title}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height * 0.023)),
              trailing: const Icon(Icons.keyboard_arrow_right),
            );
          },
        );
      },
    );
  }
}
