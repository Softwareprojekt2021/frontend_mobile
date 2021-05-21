import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class Format {
  static var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");
  static var priceFormat = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: '€');
}