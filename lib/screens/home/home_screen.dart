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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                final code = await Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  CurrenciesScreen.routeName,
                ) as String;
                if (code.isNotEmpty) {
                  await context.read<HomeStateNotifier>().addCurrency(code);
                }
              },
            )
          ],
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();

    if (state.modelList.isEmpty) {
      return SizedBox();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.modelList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCellItem(
          state.modelList[index],
          context,
        );
      },
    );
  }

  Widget _buildCellItem(
    HomeStateModel model,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            model.currencyName,
          ),
          Row(
            children: [
              Text(
                model.code,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.green,
                size: 30.0,
              ),
              Expanded(
                child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE5E8EF),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
