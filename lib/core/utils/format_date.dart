import 'package:intl/intl.dart';

String formatDateBydMMYYYY(DateTime date) {
  return DateFormat('d MMM, yyyy').format(date);
}