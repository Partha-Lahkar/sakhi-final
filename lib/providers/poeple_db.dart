// providers/person_db.dart

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sakhi/models/people.dart';

class PersonDatabaseHelper {
  static PersonDatabaseHelper? _databaseHelper;
  static Database? _database;

  // Define table and column names
  static const String personsTable = 'persons';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colRelationship = 'relationship';
  static const String colPhotoPath = 'photoPath';
  static const String colPhoneNumber = 'phoneNumber';
  static const String colAddress = 'address';

  PersonDatabaseHelper._createInstance();

  factory PersonDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = PersonDatabaseHelper._createInstance();
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
    String path = join(await getDatabasesPath(), 'persons.db');
    var personsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return personsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $personsTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colRelationship TEXT,
        $colPhotoPath TEXT,
        $colPhoneNumber TEXT,
        $colAddress TEXT
      )
    ''');
  }

  Future<int> insertPerson(Person person) async {
    Database db = await this.database;
    var result = await db.insert(
      personsTable,
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<Person>> getAllPersons() async {
    Database db = await this.database;
    List<Map<String, dynamic>> mapList =
        await db.query(personsTable, orderBy: '$colName ASC');
    List<Person> personList =
        mapList.map((item) => Person.fromMap(item)).toList();
    return personList;
  }

  Future<int> deletePerson(int id) async {
    Database db = await this.database;
    int result = await db.delete(
      personsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<void> updatePerson(Person person) async {
    Database db = await this.database;
    await db.update(
      personsTable,
      person.toMap(),
      where: '$colId = ?',
      whereArgs: [person.id],
    );
  }
}
