import 'package:sqflite/sqflite.dart';

const String savedCurrenciesTableName = 'saved_currencies';
const String _columnId = 'id';
const String _columnIndex = 'index';
const String _columnCode = 'code';

class SavedCurrency {
  int id;
  int order;
  String code;

  SavedCurrency(this.code, this.order);

  SavedCurrency.fromMap(
    Map<String, dynamic> map,
  )   : id = map[_columnId] as int,
        order = map[_columnIndex] as int,
        code = map[_columnCode] as String;

  Map<String, dynamic> toMap() {
    return {
      _columnId: id,
      _columnIndex: order,
      _columnCode: code,
    };
  }
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
    final nextIndex = count + 1;
    // Add record to the list
    final newItem = SavedCurrency(code, nextIndex);
    return _insert(db, newItem);
  }

  // Replace currency
  Future<void> replace(Database db, String newCode, int index) async {
    // Remove Current
    await db.rawDelete(
        'DELETE FROM $savedCurrenciesTableName WHERE $_columnIndex = ?',
        [index]);
    final newItem = SavedCurrency(newCode, index);
    return _insert(db, newItem);
  }

  // Insert new item
  Future<void> _insert(Database db, SavedCurrency newItem) async {
    await db.insert(
      savedCurrenciesTableName,
      newItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
