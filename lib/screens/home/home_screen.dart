import 'package:currency_converter/common/text_styles.dart';
import 'package:currency_converter/screens/currencies/currencies_screen.dart';
import 'package:currency_converter/screens/home/home_state.dart';
import 'package:currency_converter/screens/home/home_state_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<HomeStateNotifier, HomeState>(
      create: (_) => HomeStateNotifier(),
      lazy: false,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
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
    final state = context.watch<HomeState>();

    if (state.selectedCurrency == null) {
      return Center(child: _buildSelectionButton(context, 'SELECT A CURRENCY'));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Currency Selected',
            style: AppTextStyles.title,
          ),
          SizedBox(height: 30),
          Text(
            state.selectedCurrency.name,
            style: AppTextStyles.currencyName,
          ),
          SizedBox(height: 10),
          Text(
            state.selectedCurrency.code,
            style: AppTextStyles.currencyCode,
          ),
          SizedBox(height: 50),
          _buildSelectionButton(context, 'CHANGE THE CURRENCY')
        ],
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String label) {
    return ElevatedButton(
      child: Text(label),
      onPressed: () async {
        final result = await Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(
          CurrenciesScreen.routeName,
        ) as bool;
        if (result) {
          await context.read<HomeStateNotifier>().fetch();
        }
      },
    );
  }
}
