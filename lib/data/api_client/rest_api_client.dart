import 'package:currency_converter/data/api_client/api_models/currencies_response.dart';
import 'package:currency_converter/data/api_client/api_models/rates_response.dart';
import 'package:currency_converter/main/env.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_api_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  factory RestClient.create(
    Env env,
  ) {
    final dio = Dio();
    dio.interceptors.add(_AuthInterceptor(env: env));
    return _RestClient(dio, baseUrl: env.apiBaseUrl);
  }

  @GET("/list")
  Future<CurrenciesResponse> getAvailableCurrencies();

  @GET("/live")
  Future<RatesResponse> getRates();
}

class _AuthInterceptor extends InterceptorsWrapper {
  _AuthInterceptor({
    this.env,
  });

  final Env env;

  @override
  Future onRequest(RequestOptions options) async {
    final accessKey = await env.apiAccessKey;
    options.queryParameters.addAll(<String, String>{'access_key': accessKey});
    return super.onRequest(options);
  }
}
