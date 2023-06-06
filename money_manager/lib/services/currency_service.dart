import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

class CurrencyService{
  static List<String?>  getCurrencyNames(){ 
    return numberFormatSymbols.keys
      .map((key) => NumberFormat.simpleCurrency(locale: key.toString()).currencyName)
      .toSet()
      .toList();
}
}
