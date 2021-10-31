import 'package:freezed_annotation/freezed_annotation.dart';

part 'rates_response.freezed.dart';

part 'rates_response.g.dart';

@freezed
class RatesResponse with _$RatesResponse {
  const RatesResponse._();

  factory RatesResponse({
    required bool success,
    String? source,
    Map<String, num>? quotes,
  }) = _RatesResponse;

  factory RatesResponse.fromJson(Map<String, dynamic> json) =>
      _$RatesResponseFromJson(json);
}
