import 'package:currency_converter/data/api_client/rest_api_client.dart';
import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:currency_converter/data/db/sq_lite_client.dart';
import 'package:currency_converter/data/shared_preferences/app_settings.dart';
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
    final appSettings = await prefs.loadAppSettings();

    await _fetchRemoteDataIfRequired(appSettings);

    if (appSettings.selectedCurrencyCode == null) {
      return;
    }

    final dbClient = read<SQFLiteClient>();
    final selectedCurrency =
        await dbClient.getCurrency(appSettings.selectedCurrencyCode);
    if (selectedCurrency != null) {
      state = state.copyWith(selectedCurrency: selectedCurrency);
    }
  }

  Future<void> _fetchRemoteDataIfRequired(AppSettings appSettings) async {
    if (!_shouldFetchRemoteData(appSettings)) {
      return;
    }

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

    //  Refresh data no more frequently than every 30 minutes
    final prefs = read<SharedPreferencesClient>();
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
