import 'package:intl/intl.dart';

String formatNumber(num number) {
  if (number <= 999) {
    return number.toString();
  } else if (number < 10000) {
    return NumberFormat('#,##0k').format(number);
  } else {
    return NumberFormat.compact().format(number);
  }
}
