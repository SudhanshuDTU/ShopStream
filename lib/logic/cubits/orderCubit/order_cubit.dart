import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/cart/cart_item_model.dart';
import 'package:frontend/data/models/order/order_model.dart';
import 'package:frontend/data/repositories/order_repository.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/orderCubit/order_state.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/logic/services/calculation.dart';

class OrderCubit extends Cubit<OrderState> {
  final UserCubit _userCubit;
  final CartCubit _cartCubit;
  StreamSubscription? _userSubscription;
  OrderCubit(this._userCubit, this._cartCubit) : super(OrderInitialState()) {
    //initial state k liye
    _handleUserstate(_userCubit.state);

    //Listening to usercubit (for future updates)
    _userSubscription = _userCubit.stream.listen(_handleUserstate);
  }

  void _handleUserstate(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(OrderInitialState());
    }
  }

  final _orderRepository = OrderRepository();

  void _initialize(String userId) async {
    emit(OrderLoadingState(state.orders));
    try {
      List<OrderModel> orders =
          await _orderRepository.fetchOrderForUser(userId);
      emit(OrderLoadedState(orders));
    } catch (e) {
      emit(OrderErrorState(e.toString(), state.orders));
    }
  }

  Future<OrderModel?> createOrder(
      {required List<CartItemModel> items, required paymentMethod}) async {
    emit(OrderLoadingState(state.orders));
    try {
      if (_userCubit.state is! UserLoggedInState) {
        return null;
      }
      OrderModel newOrder = OrderModel(
          totalAmount: Calculations.cartTotal(items),
          items: items,
          user: (_userCubit.state as UserLoggedInState).userModel,
          status: paymentMethod == "Pay-On-Delivery"
              ? "Order Placed"
              : "Payment Pending");
      final order = await _orderRepository.createOrder(newOrder);
      List<OrderModel> orders = [order, ...state.orders];
      emit(OrderLoadedState(orders));

      //clear the cart
      _cartCubit.clearCart();

      return order;
    } catch (e) {
      emit(OrderErrorState(e.toString(), state.orders));
      return null;
    }
  }

  Future<bool> updateOrder(OrderModel orderModel,
      {String? paymentId, String? signature}) async {
    try {
      OrderModel updatedOrder = await _orderRepository.updateOrder(orderModel,
          paymentId: paymentId, signature: signature);

      int index = state.orders.indexOf(updatedOrder);
      if (index == -1) {
        return false;
      }

      List<OrderModel> newList = state.orders;
      newList[index] = updatedOrder;
      emit(OrderLoadedState(newList));
      return true;
    } catch (ex) {
      emit(OrderErrorState(ex.toString(), state.orders));
      return false;
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _userSubscription?.cancel();
    return super.close();
  }
}
