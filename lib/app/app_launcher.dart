import 'package:currency_converter/app/app.dart';
import 'package:currency_converter/main/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

Future<void> launchApp({
  @required Env env,
}) async {
  // Here is some space for initializations such as Firebase.
  return runApp(
    App(
      env: env,
    ),
  );
}
