import 'package:currency_converter/data/api_client/rest_api_client.dart';
import 'package:currency_converter/screens/currencies/currencies_state.dart';
import 'package:state_notifier/state_notifier.dart';

class CurrenciesStateNotifier extends StateNotifier<CurrenciesState>
    with LocatorMixin {
  CurrenciesStateNotifier() : super(CurrenciesState());

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetch() async {
    final apiClient = read<RestApiClient>();
    final currenciesResponse = await apiClient.getAvailableCurrencies();
    if (currenciesResponse == null) {
      return;
    }

    final list = currenciesResponse.currencies.entries
        .map((e) => CurrencyDataModel(e.key, e.value))
        .toList();
    state = state.copyWith(currencies: list);
  }
}
