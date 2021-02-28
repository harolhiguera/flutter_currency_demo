import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:currency_converter/data/db/saved_currencies_provider.dart';
import 'package:currency_converter/data/db/usd_rates_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const String _databaseName = 'currency_demo.db';
const int _databaseVersion = 1;

class SQFLiteClient {
  Database _database;
  CurrenciesProvider _currenciesProvider;
  UsdRateProvider _usdRateProvider;
  SavedCurrencyProvider _savedCurrencyProvider;

  SQFLiteClient() {
    _currenciesProvider = CurrenciesProvider();
    _usdRateProvider = UsdRateProvider();
    _savedCurrencyProvider = SavedCurrencyProvider();
  }

  Future<Database> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();
    return _database;
  }

  Future<Database> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, _databaseName);
    final database = openDatabase(dbPath,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure);
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_currenciesProvider.openTableQuery());
    await db.execute(_usdRateProvider.openTableQuery());
    await db.execute(_savedCurrencyProvider.openTableQuery());
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /*
   * Currencies
   */

  Future<List<Currency>> getCurrencies(List<String> codes) async {
    final client = await _db;
    return _currenciesProvider.getCurrencies(client, codes);
  }

  Future<void> replaceAllCurrencies(List<Currency> currencies) async {
    final client = await _db;
    return _currenciesProvider.replaceAll(client, currencies);
  }

  Future<List<Currency>> getAllCurrencies() async {
    final client = await _db;
    return _currenciesProvider.getAllCurrencies(client);
  }

  /*
   * Usd Rates
   */

  Future<void> replaceAllUsdRates(List<UsdRate> usdRates) async {
    final client = await _db;
    return _usdRateProvider.replaceAll(client, usdRates);
  }

  Future<List<UsdRate>> getUsdRates(List<String> codes) async {
    final client = await _db;
    return _usdRateProvider.getRates(client, codes);
  }

  /*
   * Saved Currencies
   */

  Future<List<SavedCurrency>> getAllSavedCurrencies() async {
    final client = await _db;
    return _savedCurrencyProvider.getAll(client);
  }

  Future<void> addSavedCurrency(String code) async {
    final client = await _db;
    return _savedCurrencyProvider.add(client, code);
  }

  Future<void> replaceSavedCurrency(String newCode, int index) async {
    final client = await _db;
    return _savedCurrencyProvider.replace(client, newCode, index);
  }
}
