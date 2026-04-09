import 'package:intl/intl.dart';

String formatRupiah(dynamic number) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(number);
}
