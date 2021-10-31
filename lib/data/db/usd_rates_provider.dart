import 'package:sqflite/sqflite.dart';

const String usdRatesTableName = 'usd_rates';
const String _columnId = 'id';
const String _columnRate = 'rate';
const String _columnCode = 'code';

class UsdRate {
  int id;
  num rate;
  String code;

  UsdRate.fromMap(
    Map<String, dynamic> map,
  )   : id = map[_columnId] as int,
        rate = map[_columnRate] as num,
        code = map[_columnCode] as String;
}

class UsdRateProvider {
  String openTableQuery() {
    return '''
      CREATE TABLE $usdRatesTableName (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $_columnRate REAL,
      $_columnCode TEXT)
      ''';
  }

  Future<void> replaceAll(Database db, Map<String, num> usdRates) async {
    await _deleteAll(db);
    await _add(db, usdRates);
  }

  Future<void> _add(Database db, Map<String, num> usdRates) async {
    final batch = db.batch();
    usdRates.entries.forEach((e) {
      batch.insert(usdRatesTableName, {
        _columnCode: e.key.substring(3),
        _columnRate: e.value,
      });
    });
    await batch.commit();
  }

  Future<void> _deleteAll(Database db) async {
    await db.delete(usdRatesTableName);
  }

  Future<List<UsdRate>> getRates(
    Database db,
    List<String> codes,
  ) async {
    final maps = await _getRates(db, codes);
    return maps.map((e) => UsdRate.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> _getRates(
    Database db,
    List<String> codes,
  ) async {
    return await db.query(
      usdRatesTableName,
      where: "$_columnCode IN (${codes.map((_) => '?').join(', ')})",
      whereArgs: codes,
    );
  }
}
