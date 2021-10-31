import 'package:sqflite/sqflite.dart';

const String savedCurrenciesTableName = 'saved_currencies';
const String _columnId = 'id';
const String _columnIndex = '_index';
const String _columnCode = 'code';

class SavedCurrency {
  int id;
  int index;
  String code;

  SavedCurrency.fromMap(
    Map<String, dynamic> map,
  )   : id = map[_columnId] as int,
        index = map[_columnIndex] as int,
        code = map[_columnCode] as String;
}

class SavedCurrencyProvider {
  String openTableQuery() {
    return '''
      CREATE TABLE $savedCurrenciesTableName (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $_columnIndex INTEGER,
      $_columnCode TEXT)
      ''';
  }

  // Get all Currencies ordered by index

  Future<List<SavedCurrency>> getAll(Database db) async {
    final maps = await _getSortedShSavedCurrencies(db);
    return maps.map((e) => SavedCurrency.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> _getSortedShSavedCurrencies(
    Database db,
  ) async {
    return db.rawQuery(''
        'SELECT * FROM $savedCurrenciesTableName '
        'ORDER BY $_columnIndex ASC');
  }

  // Add Currency
  Future<void> add(Database db, String code) async {
    // Get the current quantity
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $savedCurrenciesTableName'));
    final nextIndex = count ?? 0 + 1;
    // Add record to the list
    return _insert(
      db,
      code: code,
      index: nextIndex,
    );
  }

  // Replace currency
  Future<void> replace(Database db, String newCode, int index) async {
    // Remove Current
    await db.rawDelete(
        'DELETE FROM $savedCurrenciesTableName WHERE $_columnIndex = ?',
        [index]);
    return _insert(
      db,
      code: newCode,
      index: index,
    );
  }

  // Insert new item
  Future<void> _insert(
    Database db, {
    required String code,
    required int index,
  }) async {
    await db.insert(
      savedCurrenciesTableName,
      {
        _columnIndex: index,
        _columnCode: code,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
