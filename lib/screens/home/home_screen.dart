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

    if (!state.hasSelectedCurrency) {
      return Center(
        child: ElevatedButton(
          child: Text('SELECT A CURRENCY'),
          onPressed: () async {
            final result = await Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(
              CurrenciesScreen.routeName,
            ) as bool;
          },
        ),
      );
    }
    return SizedBox();
  }
}
