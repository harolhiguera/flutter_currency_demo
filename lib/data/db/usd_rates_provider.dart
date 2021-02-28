import 'package:sqflite/sqflite.dart';

const String usdRatesTableName = 'usd_rates';
const String _columnId = 'id';
const String _columnRate = 'rate';
const String _columnCode = 'code';

class UsdRate {
  int id;
  int rate;
  String code;

  UsdRate(this.code, this.rate);

  UsdRate.fromMap(
    Map<String, dynamic> map,
  )   : id = map[_columnId] as int,
        rate = map[_columnRate] as int,
        code = map[_columnCode] as String;

  Map<String, dynamic> toMap() {
    return {
      _columnId: id,
      _columnRate: rate,
      _columnCode: code,
    };
  }
}

class UsdRateProvider {
  String openTableQuery() {
    return '''
      CREATE TABLE $usdRatesTableName (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $_columnRate INTEGER,
      $_columnCode TEXT)
      ''';
  }

  Future<void> replaceAll(Database db, List<UsdRate> usdRates) async {
    await _deleteAll(db);
    await _add(db, usdRates);
  }

  Future<void> _add(Database db, List<UsdRate> usdRates) async {
    final batch = db.batch();
    for (final currency in usdRates) {
      final map = currency.toMap();
      batch.insert(usdRatesTableName, map);
    }
    await batch.commit();
  }

  Future<void> _deleteAll(Database db) async {
    return db.delete(usdRatesTableName);
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
    return await db.rawQuery(
        'SELECT * FROM $usdRatesTableName '
        'WHERE $_columnCode IN ?',
        [codes]);
  }
}
