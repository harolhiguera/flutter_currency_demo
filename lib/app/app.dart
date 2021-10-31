import 'package:currency_converter/data/network/rest_api_client.dart';
import 'package:currency_converter/data/db/sq_lite_client.dart';
import 'package:currency_converter/data/shared_preferences/shared_preferences_client.dart';
import 'package:currency_converter/main/env.dart';
import 'package:currency_converter/screens/currencies/currencies_screen.dart';
import 'package:currency_converter/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  final Env env;

  const App({
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      builder: (context, child) {
        if (child == null) {
          return SizedBox();
        }
        return _Builder(
          env: env,
          childWidget: child,
        );
      },
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        CurrenciesScreen.routeName: (_) => CurrenciesScreen(),
      },
    );
  }
}

class _Builder extends StatelessWidget {
  final Env env;
  final Widget childWidget;

  const _Builder({
    required this.env,
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    // https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html
    return MultiProvider(
      providers: [
        Provider.value(
          value: env,
        ),
        Provider<SharedPreferencesClient>(
          create: (BuildContext context) => SharedPreferencesClient(),
        ),
        Provider<RestApiClient>(
          create: (BuildContext context) => RestApiClient.create(env),
        ),
        Provider(
          create: (BuildContext context) => SQFLiteClient(),
        ),
      ],
      child: childWidget,
    );
  }
}
