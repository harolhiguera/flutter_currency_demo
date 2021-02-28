import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:currency_converter/data/db/saved_currencies_provider.dart';
import 'package:currency_converter/screens/home/home_state.dart';

class HomeBuilder {
  static List<HomeStateModel> buildModelList(
    List<SavedCurrency> currentSavedCurrencies,
    List<Currency> currencyList,
  ) {
    return currentSavedCurrencies
        .map((e) => HomeStateModel(
              currencyName: currencyList
                  .firstWhere((element) => element.code == e.code)
                  .name,
              index: e.index,
              code: e.code,
            ))
        .toList();
  }
}
