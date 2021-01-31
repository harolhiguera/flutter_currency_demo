import 'package:currency_converter/data/db/sq_lite_client.dart';
import 'package:currency_converter/data/shared_preferences/shared_preferences_client.dart';
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
    final dbClient = read<SQFLiteClient>();
    final currencies = await dbClient.getAllCurrencies();
    if (currencies.isEmpty) {
      return;
    }
    state = state.copyWith(currencies: currencies);
  }

  Future<void> storeSelectedCurrency(String code) async {
    final prefs = read<SharedPreferencesClient>();
    return await prefs.setSelectedCurrencyCode(selectedCurrencyCode: code);
  }
}
