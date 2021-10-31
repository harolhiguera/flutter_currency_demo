import 'package:currency_converter/data/network/api_models/currencies/currencies_response.dart';
import 'package:currency_converter/data/network/api_models/rates/rates_response.dart';
import 'package:currency_converter/main/env.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_api_client.g.dart';

@RestApi()
abstract class RestApiClient {
  factory RestApiClient(Dio dio, {String baseUrl}) = _RestApiClient;

  factory RestApiClient.create(
    Env env,
  ) {
    final dio = Dio();
    dio.interceptors.add(_AuthInterceptor(env: env));
    return _RestApiClient(dio, baseUrl: env.apiBaseUrl);
  }

  @GET("/list")
  Future<CurrenciesResponse> getAvailableCurrencies();

  @GET("/live")
  Future<RatesResponse> getRates();
}

class _AuthInterceptor extends InterceptorsWrapper {
  _AuthInterceptor({
    required this.env,
  });

  final Env env;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessKey = await env.apiAccessKey;
    options.queryParameters.addAll(<String, String>{'access_key': accessKey});
    return handler.next(options);
  }
}
