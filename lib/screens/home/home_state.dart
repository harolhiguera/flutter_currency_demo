import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    @nullable Currency selectedCurrency,
  }) = _HomeState;
}
