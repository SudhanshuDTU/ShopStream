import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/cart/cart_item_model.dart';
import 'package:frontend/data/models/product/product_model.dart';
import 'package:frontend/data/repositories/cart_repository.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';

class CartCubit extends Cubit<CartState> {
  final UserCubit _userCubit;
  StreamSubscription? _userSubscription;
  CartCubit(this._userCubit) : super(CartInitialState()) {
    //initial state k liye
    _handleUserstate(_userCubit.state);

    //Listening to usercubit (for future updates)
    _userSubscription = _userCubit.stream.listen(_handleUserstate);
  }
  void _handleUserstate(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(CartInitialState());
    }
  }

  final _cartRepository = CartRepository();

  void sortAndLoad(List<CartItemModel> items) async {
    //cart me sorted krke dikhane k liye
    items.sort((a, b) => a.product!.title!.compareTo(b.product!.title!));
    emit(CartLoadedState(items));
  }

  void _initialize(String userId) async {
    emit(CartLoadingState(state.items));
    try {
      final items = await _cartRepository.fetchCartForUser(userId);
      sortAndLoad(items);
    } catch (e) {
      emit(CartErrorState(e.toString(), state.items));
    }
  }

  void addToCart(ProductModel productModel, int quantity) async {
    emit(CartLoadingState(state.items));
    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;
        CartItemModel newItem =
            CartItemModel(quantity: quantity, product: productModel);
        final updateditems =
            await _cartRepository.addToCart(newItem, userState.userModel.sId!);
        sortAndLoad(updateditems);
      } else {
        throw "An Error occured while adding the item!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  bool cartContains(ProductModel productModel) {
    if (state.items.isNotEmpty) {
      final founditems = state.items
          .where((item) => item.product!.sId! == productModel.sId)
          .toList();
      if (founditems.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void removeFromCart(ProductModel productModel) async {
    emit(CartLoadingState(state.items));
    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;

        final updateditems = await _cartRepository.removeFromCart(
            productModel.sId!, userState.userModel.sId!);
        sortAndLoad(updateditems);
      } else {
        throw "An Error occured while removing the item!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  void clearCart() async {
    emit(CartLoadedState([]));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _userSubscription?.cancel();
    return super.close();
  }
}
