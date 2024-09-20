import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toStringWithFormat() {
    return DateFormat("EEE, dd MMM yyyy").format(this);
  }
}
