import 'package:currency_converter/data/api_client/rest_api_client.dart';
import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:currency_converter/data/db/sq_lite_client.dart';
import 'package:currency_converter/data/db/usd_rates_provider.dart';
import 'package:currency_converter/data/shared_preferences/app_settings.dart';
import 'package:currency_converter/data/shared_preferences/shared_preferences_client.dart';
import 'package:currency_converter/screens/home/home_state.dart';
import 'package:currency_converter/screens/home/home_builder.dart';
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
    await _fetchRemoteDataIfRequired();
    final dbClient = read<SQFLiteClient>();

    final currentSavedCurrencies = await dbClient.getAllSavedCurrencies();
    final codeList = currentSavedCurrencies.map((e) => e.code).toList();
    final currencyList = await dbClient.getCurrencies(codeList);

    final modelList =
        HomeBuilder.buildModelList(currentSavedCurrencies, currencyList);

    state = state.copyWith(
      modelList: modelList,
    );
  }

  Future<void> addCurrency(String code) async {
    final dbClient = read<SQFLiteClient>();
    await dbClient.addSavedCurrency(code);
    await fetch();
  }

  Future<void> _fetchRemoteDataIfRequired() async {
    final prefs = read<SharedPreferencesClient>();
    final appSettings = await prefs.loadAppSettings();

    if (!_shouldFetchRemoteData(appSettings)) {
      return;
    }

    final apiClient = read<RestApiClient>();
    final currenciesResponse = await apiClient.getAvailableCurrencies();
    final ratesResponse = await apiClient.getRates();
    if (currenciesResponse == null || ratesResponse == null) {
      return;
    }

    final dbClient = read<SQFLiteClient>();

    // 1. Update currencies
    await dbClient.replaceAllCurrencies(currenciesResponse.currencies.entries
        .map((e) => Currency(e.key, e.value))
        .toList());
    // 2. Update Rates
    await dbClient.replaceAllUsdRates(ratesResponse.quotes.entries
        .map((e) => UsdRate(e.key.substring(3), e.value))
        .toList());

    //  Refresh data no more frequently than every 30 minutes
    await prefs.setNextUpdatedAt(
      nextUpdatedAt:
          DateTime.now().add(Duration(minutes: 30)).toIso8601String(),
    );
  }

  bool _shouldFetchRemoteData(AppSettings appSettings) {
    if (appSettings.nextUpdatedAt == null) {
      return true;
    }
    final nextUpdatedAt = DateTime.parse(appSettings.nextUpdatedAt);
    return DateTime.now().isAfter(nextUpdatedAt);
  }
}
