import 'dart:ffi';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       businessName TEXT,
       businessType TEXT,
       noEmployees INTEGER,
       noCustomers INTEGER,
       income INTEGER,
       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "business_management.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      });
  }

  static Future<int> createData(
      String businessName,
      String? businessType,
      int noEmployees,
      int noCustomers,
      int income) async{
    final db = await SqlHelper.db();

    final data = {
      'businessName': businessName,
      'businessType': businessType,
      'noEmployees': noEmployees,
      'noCustomers': noCustomers,
      'income': income};

    final id = await db.insert('data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SqlHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SqlHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1 );

  }

  static Future<int> updateData(int? id, String businessName, String? businessType,
      int noEmployees, int noCustomers, int income) async {

    final db = await SqlHelper.db();
    final data  = {
      'businessName': businessName,
      'businessType': businessType,
      'noEmployees': noEmployees,
      'noCustomers': noCustomers,
      'income': income
    };

    final result = await db.update('data', data, where: "id = ?",
        whereArgs: [id]);

      return result;
    }

    static Future<void> deleteData(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }

}