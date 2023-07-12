import 'package:flutter/widgets.dart';

class OrderDetailProvider with ChangeNotifier {
  String? paymentMethod = "PayNow";
  changePaymentMethod(String? value) {
    paymentMethod = value;
    notifyListeners();
  }
}
