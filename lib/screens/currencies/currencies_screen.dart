import 'package:currency_converter/common/text_styles.dart';
import 'package:currency_converter/screens/currencies/currencies_state.dart';
import 'package:currency_converter/screens/currencies/currencies_state_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class CurrenciesScreen extends StatelessWidget {
  static const routeName = '/currencies_screen';

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<CurrenciesStateNotifier, CurrenciesState>(
      create: (_) => CurrenciesStateNotifier(),
      lazy: false,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text('Currencies'),
          centerTitle: true,
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurrenciesState>();

    if (state.currencies.isEmpty) {
      return Center(
        child: Text('Sorry, please try again in a moment.'),
      );
    }

    return ListView.separated(
      itemCount: state.currencies.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, int position) => _ListCell(
        code: state.currencies[position].code,
        name: state.currencies[position].name,
        onSelectedItem: (code) => _onSelectedItem(context, code),
      ),
      separatorBuilder: (context, _) => Container(
        height: 1,
        color: Colors.black26,
        margin: const EdgeInsets.symmetric(horizontal: 25),
      ),
    );
  }

  Future<void> _onSelectedItem(
      BuildContext context, String currencyCode) async {
    Navigator.of(context).pop(currencyCode);
  }
}

class _ListCell extends StatelessWidget {
  const _ListCell({
    this.code,
    this.name,
    this.onSelectedItem,
  });

  final String code;
  final String name;
  final void Function(String) onSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onSelectedItem(code),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.currencyName,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  code,
                  style: AppTextStyles.currencyCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
