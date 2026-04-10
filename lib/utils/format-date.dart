import 'package:intl/intl.dart';

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
  return formattedDate;
}
