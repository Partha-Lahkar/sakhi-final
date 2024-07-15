import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sakhi/models/medicine.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  // Define table and column names
  static const String medicinesTable = 'medicines';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPhotoPath = 'photoPath';
  static const String colDaysToTake = 'daysToTake';
  static const String colTimesToTake = 'timesToTake';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'medicines.db');
    var medicinesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return medicinesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $medicinesTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colPhotoPath TEXT,
        $colDaysToTake TEXT,
        $colTimesToTake TEXT
      )
    ''');
  }

  Future<int> insertMedicine(Medicine medicine) async {
    Database db = await this.database;
    var result = await db.insert(
      medicinesTable,
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _logMedicineTable(); // Log the medicines after insertion
    return result;
  }

  Future<List<Medicine>> getMedicineList(String day) async {
    Map<String, int> dayMap = {
      'Sunday': 0,
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
    };

    Database db = await this.database;
    List<Map<String, dynamic>> mapList = await db.rawQuery(
      'SELECT * FROM $medicinesTable WHERE $colDaysToTake LIKE ?',
      ['%${dayMap[day]}%'],
    );

    List<Medicine> medicineList =
        mapList.map((item) => Medicine.fromMap(item)).toList();
    return medicineList;
  }

  Future<int> deleteMedicine(int id) async {
    Database db = await this.database;
    // int result=await db.delete(

    // ),

    try {
      int result = await db.delete(
        medicinesTable,
        where: '$colId = ?',
        whereArgs: [id],
      );
      _logMedicineTable(); // Log the medicines after deletion
      return result;
    } catch (e) {
      print('Error deleting medicine: $e');
      return 0; // Return appropriate error code or handle error as needed
    }
  }

  Future<void> _logMedicineTable() async {
    Database db = await this.database;
    List<Map<String, dynamic>> medicines =
        await db.rawQuery('SELECT * FROM $medicinesTable');
    print('Logging Medicines Table:');
    medicines.forEach((medicine) {
      print('Medicine ID: ${medicine[colId]}, Name: ${medicine[colName]}, '
          'Days to Take: ${medicine[colDaysToTake]}, Times to Take: ${medicine[colTimesToTake]}');
    });
  }
}
