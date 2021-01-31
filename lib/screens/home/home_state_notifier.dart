import 'package:currency_converter/data/api_client/rest_api_client.dart';
import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:currency_converter/data/db/sq_lite_client.dart';
import 'package:currency_converter/data/shared_preferences/shared_preferences_client.dart';
import 'package:currency_converter/screens/home/home_state.dart';
import 'package:state_notifier/state_notifier.dart';

class HomeStateNotifier extends StateNotifier<HomeState> with LocatorMixin {
  HomeStateNotifier() : super(HomeState());

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
    final prefs = read<SharedPreferencesClient>();
    final appUser = await prefs.loadAppSettings();
    await _fetchDataIfRequired();
    if (appUser.selectedCurrencyCode == null) {
      return;
    }
  }

  Future<void> _fetchDataIfRequired() async {
    final apiClient = read<RestApiClient>();
    final currenciesResponse = await apiClient.getAvailableCurrencies();
    if (currenciesResponse == null) {
      return;
    }
    final currencies = currenciesResponse.currencies.entries
        .map((e) => Currency(e.key, e.value))
        .toList();

    final dbClient = read<SQFLiteClient>();
    await dbClient.replaceAllCurrencies(currencies);
  }
}
