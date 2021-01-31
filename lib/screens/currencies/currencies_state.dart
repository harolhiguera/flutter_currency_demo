import 'package:freezed_annotation/freezed_annotation.dart';

part 'currencies_state.freezed.dart';

@freezed
abstract class CurrenciesState with _$CurrenciesState {
  factory CurrenciesState({
    @Default(<CurrencyDataModel>[]) List<CurrencyDataModel> currencies,
  }) = _CurrenciesState;
}

class CurrencyDataModel {
  CurrencyDataModel(
    this.code,
    this.name,
  );

  final String code;
  final String name;
}
