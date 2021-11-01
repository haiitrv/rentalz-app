
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rentalz_app/sqlite/data_model.dart';

class DB {
  Future<Database> initDB() async {
    // initialize database
    // Get a path to store data
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'MYDB2.db'),
      onCreate: (database, version) async {
        // Create table
        await database.execute('''
          CREATE TABLE MYTable2(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            property TEXT NOT NULL,
            bedrooms TEXT NOT NULL,
            price TEXT NOT NULL,
            furniture TEXT NOT NULL,
            reporter TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert data
  Future<bool> insertData(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert('MYTable2', dataModel.toMap());
    return true;
  }

  // Get data
  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.query('MYTable2');
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  // Edit data
  Future<void> update(DataModel dataModel, int id) async {
    final Database db = await initDB();
    await db.update('MYTable2', dataModel.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  // Delete data
// Edit data
  Future<void> delete(int id) async {
    final Database db = await initDB();
    await db.delete('MYTable2', where: 'id = ?', whereArgs: [id]);
  }
}