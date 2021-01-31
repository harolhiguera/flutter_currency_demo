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
    if (appUser.selectedCurrencyCode == null) {
      return;
    }
  }
}
