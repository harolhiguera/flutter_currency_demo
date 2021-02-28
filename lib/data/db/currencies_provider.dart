import 'package:sqflite/sqflite.dart';

const String currenciesTableName = 'currencies';
const String _columnId = 'id';
const String _columnName = 'currency_name';
const String _columnCode = 'currency_code';

class Currency {
  int id;
  String name;
  String code;

  Currency(this.code, this.name);

  Currency.fromMap(
    Map<String, dynamic> map,
  )   : id = map[_columnId] as int,
        name = map[_columnName] as String,
        code = map[_columnCode] as String;

  Map<String, dynamic> toMap() {
    return {
      _columnId: id,
      _columnName: name,
      _columnCode: code,
    };
  }
}

class CurrenciesProvider {
  String openTableQuery() {
    return '''
      CREATE TABLE $currenciesTableName (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $_columnName TEXT,
      $_columnCode TEXT)
      ''';
  }

  Future<List<Currency>> getAllCurrencies(Database db) async {
    final maps = await _getSortedCurrencies(db);
    return maps.map((e) => Currency.fromMap(e)).toList();
  }

  Future<void> replaceAll(Database db, List<Currency> currencies) async {
    await _deleteAll(db);
    await _add(db, currencies);
  }

  Future<List<Currency>> getCurrencies(Database db, List<String> codes) async {
    final maps = await db.query(
      currenciesTableName,
      where: "$_columnCode IN (${codes.map((_) => '?').join(', ')})",
      whereArgs: codes,
    );
    return maps.map((e) => Currency.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> _getSortedCurrencies(
    Database db,
  ) async {
    return db.rawQuery(''
        'SELECT * FROM $currenciesTableName '
        'ORDER BY $_columnName');
  }

  Future<void> _add(Database db, List<Currency> currencies) async {
    final batch = db.batch();
    for (final currency in currencies) {
      final map = currency.toMap();
      batch.insert(currenciesTableName, map);
    }
    await batch.commit();
  }

  Future<void> _deleteAll(Database db) async {
    return db.delete(currenciesTableName);
  }
}
