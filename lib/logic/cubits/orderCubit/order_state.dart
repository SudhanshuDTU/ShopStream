import 'package:frontend/data/models/order/order_model.dart';

abstract class OrderState {
  final List<OrderModel> orders;

  OrderState(this.orders);
}

class OrderInitialState extends OrderState {
  OrderInitialState() : super([]);
}

class OrderLoadingState extends OrderState {
  OrderLoadingState(super.items);
}

class OrderLoadedState extends OrderState {
  OrderLoadedState(super.items);
}

class OrderErrorState extends OrderState {
  final String message;
  OrderErrorState(this.message, super.items);
}
