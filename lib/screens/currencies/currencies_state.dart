import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'currencies_state.freezed.dart';

@freezed
class CurrenciesState with _$CurrenciesState {
  const CurrenciesState._();

  const factory CurrenciesState({
    @Default(<Currency>[]) List<Currency> currencies,
  }) = _CurrenciesState;
}
