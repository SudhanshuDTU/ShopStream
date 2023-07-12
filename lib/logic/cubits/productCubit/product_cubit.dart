import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repositories/product_repository.dart';
import 'package:frontend/logic/cubits/productCubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitialState()) {
    _initialize();
  }

  final _productRepository = ProductRepository();

  void _initialize() async {
    emit(ProductLoadingState(state.products));
    try {
      final products = await _productRepository.fetchAllProducts();
      emit(ProductLoadedState(products));
    } catch (ex) {
      emit(ProductErrorState(ex.toString(), state.products));
    }
  }
}
