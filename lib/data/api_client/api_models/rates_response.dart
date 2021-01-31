import 'package:freezed_annotation/freezed_annotation.dart';

part 'rates_response.freezed.dart';

part 'rates_response.g.dart';

@freezed
abstract class RatesResponse with _$RatesResponse {
  factory RatesResponse({
    bool success,
    String source,
    Map<String, double> quotes,
  }) = _RatesResponse;

  factory RatesResponse.fromJson(Map<String, dynamic> json) =>
      _$RatesResponseFromJson(json);
}
