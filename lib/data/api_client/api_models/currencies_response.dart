import 'package:freezed_annotation/freezed_annotation.dart';

part 'currencies_response.freezed.dart';

part 'currencies_response.g.dart';

@freezed
abstract class CurrenciesResponse with _$CurrenciesResponse {
  factory CurrenciesResponse({
    bool success,
    String terms,
    String privacy,
    Map<String, String> currencies,
  }) = _CurrenciesResponse;

  factory CurrenciesResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesResponseFromJson(json);
}
