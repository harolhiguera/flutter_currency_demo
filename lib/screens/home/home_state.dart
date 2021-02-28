import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    @Default(<HomeStateModel>[]) List<HomeStateModel> modelList,
  }) = _HomeState;
}

class HomeStateModel {
  HomeStateModel({
    @required this.currencyName,
    @required this.index,
    @required this.code,
  });

  final String currencyName;
  final int index;
  final String code;
}
