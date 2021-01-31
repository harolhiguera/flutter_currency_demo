import 'package:currency_converter/data/db/currencies_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const String _databaseName = 'currency_demo.db';
const int _databaseVersion = 1;

class SQFLiteClient {
  Database _database;
  CurrenciesProvider _currenciesProvider;

  SQFLiteClient() {
    _currenciesProvider = CurrenciesProvider();
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

  Future<Currency> getCurrency(String code) async {
    final client = await _db;
    return _currenciesProvider.getCurrency(client, code);
  }

  Future<void> replaceAllCurrencies(List<Currency> currencies) async {
    final client = await _db;
    return _currenciesProvider.replaceAll(client, currencies);
  }

  Future<List<Currency>> getAllCurrencies() async {
    final client = await _db;
    return _currenciesProvider.getAllCurrencies(client);
  }
}
