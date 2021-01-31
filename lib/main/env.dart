class Env {
  Env({
    this.apiBaseUrl,
    this.apiAccessKey,
  });

  final String apiBaseUrl;
  final String apiAccessKey;
}

class EnvValue {
  static final Env development = Env(
    apiBaseUrl: 'http://api.currencylayer.com',
    apiAccessKey: '5df5020c8cb1fa3194d5bd290700d656',
  );
  static final Env production = Env(
    apiBaseUrl: 'http://api.currencylayer.com',
    apiAccessKey: '5df5020c8cb1fa3194d5bd290700d656',
  );
}
