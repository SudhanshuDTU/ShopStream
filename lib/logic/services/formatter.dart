import 'package:intl/intl.dart';

class Formatter {
  static String formatPrice(double price) {
    final numberformat = NumberFormat("#,##,###");
    return numberformat.format(price);
  }

  static String formatDate(DateTime date) {
    DateTime localDate = date.toLocal();
    final dateformat = DateFormat("dd MMM y, hh:mm a");
    return dateformat.format(localDate);
  }
}
