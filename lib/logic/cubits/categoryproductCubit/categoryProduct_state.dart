import 'package:frontend/data/models/product/product_model.dart';

abstract class CategoryProductState {
  final List<ProductModel> products;

  CategoryProductState(this.products);
}

class CategoryProductInitialState extends CategoryProductState {
  CategoryProductInitialState() : super([]);
}

class CategoryProductLoadingState extends CategoryProductState {
  CategoryProductLoadingState(super.categories);
}

class CategoryProductLoadedState extends CategoryProductState {
  CategoryProductLoadedState(super.categories);
}

class CategoryProductErrorState extends CategoryProductState {
  final String message;
  CategoryProductErrorState(super.categories, this.message);
}
