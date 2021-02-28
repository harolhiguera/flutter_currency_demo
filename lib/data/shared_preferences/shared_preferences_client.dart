import 'dart:convert';

import 'package:currency_converter/data/shared_preferences/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClient {
  static const _keyAppSettings = 'app_settings';

  Future<void> setNextUpdatedAt({String nextUpdatedAt}) async {
    final newSettings = (await loadAppSettings()).copyWith(
      nextUpdatedAt: nextUpdatedAt,
    );
    await _updateAppSettings(newSettings);
  }

  Future<AppSettings> loadAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyAppSettings)) {
      return const AppSettings();
    }

    final value = prefs.getString(_keyAppSettings);
    final map = jsonDecode(value) as Map<String, dynamic>;
    return AppSettings.fromJson(map);
  }

  Future<void> _updateAppSettings(AppSettings appSettings) async {
    final prefs = await SharedPreferences.getInstance();
    final value = jsonEncode(appSettings.toJson());
    await prefs.setString(_keyAppSettings, value);
  }
}
