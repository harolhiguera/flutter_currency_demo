import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const AppSettings._();

  factory AppSettings({
    String? nextUpdatedAt,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
