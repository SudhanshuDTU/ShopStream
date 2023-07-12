import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/category/category_model.dart';
import 'package:frontend/data/repositories/category_repository.dart';
import 'package:frontend/logic/cubits/categoryCubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState()) {
    _initialize();
  }

  final _categoryRepository = CategoryRepository();

  void _initialize() async {
    emit(CategoryLoadingState(state.categories));
    try {
      List<CategoryModel> categories =
          await _categoryRepository.fetchAllCategories();
      emit(CategoryLoadedState(categories));
    } catch (e) {
      emit(CategoryErrorState(state.categories, e.toString()));
    }
  }
}
