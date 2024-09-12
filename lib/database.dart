import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:diabetes_app/models/lesson.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diabetes_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        birthdate TEXT,
        gender TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE blood_sugar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        level REAL,
        date TEXT,
        time TEXT,
        moment TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE blood_pressure (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        systolic INTEGER,
        diastolic INTEGER,
        pulse INTEGER,
        date TEXT,
        time TEXT,
        moment TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE nutrition (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        meal_type TEXT,
        calories REAL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        steps INTEGER,
        calories_burned REAL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        daily_steps_goal INTEGER,
        daily_calories_goal REAL,
        weekly_activity_goal INTEGER,
        weight_goal REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE chatbot (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        question TEXT,
        answer TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        description TEXT,
        status TEXT,
        image TEXT
      )
    ''');

    // Insert sample data into lessons table
    await db.insert('lessons', {
      'title': 'Giới thiệu chương trình cho người tiểu đường',
      'category': 'Bệnh lý',
      'description': 'Chưa học',
      'status': 'Chưa học',
      'image': 'assets/lesson_image_1.png'
    });

    await db.insert('lessons', {
      'title': 'Hệ đơn vị đo lường thực phẩm của chúng tôi',
      'category': 'Dinh dưỡng',
      'description': 'Chưa học',
      'status': 'Chưa học',
      'image': 'assets/lesson_image_2.png'
    });

    await db.insert('lessons', {
      'title': 'Tổng quan các chất dinh dưỡng cần thiết',
      'category': 'Dinh dưỡng',
      'description': 'Chưa học',
      'status': 'Chưa học',
      'image': 'assets/lesson_image_3.png'
    });

    await db.insert('lessons', {
      'title': 'Nguyên tắc của chế độ ăn ĐTĐ',
      'category': 'Dinh dưỡng',
      'description': 'Chưa học',
      'status': 'Chưa học',
      'image': 'assets/lesson_image_4.png'
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          birthdate TEXT,
          gender TEXT,
          password TEXT
        )
      ''');
    }
  }

  // Add a user to the users table
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // Fetch the list of lessons from the lessons table
  Future<List<Lesson>> getLessons() async {
    final db = await database;
    final res = await db.query('lessons');
    List<Lesson> list = res.isNotEmpty ? res.map((c) => Lesson.fromMap(c)).toList() : [];
    return list;
  }

  Future<Map<String, dynamic>?> getUserByPhoneAndPassword(String phone, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'phone = ? AND password = ?',
      whereArgs: [phone, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Insert blood sugar data into the blood_sugar table
  Future<int> insertBloodSugar(Map<String, dynamic> bloodSugar) async {
    final db = await database;
    return await db.insert('blood_sugar', bloodSugar);
  }

  // Fetch the latest blood sugar entry for a user
  Future<Map<String, dynamic>?> getLatestBloodSugar(int userId) async {
    final db = await database;
    final result = await db.query(
      'blood_sugar',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Fetch the minimum blood sugar level for a user
  Future<double?> getMinBloodSugar(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MIN(level) AS min_level FROM blood_sugar WHERE user_id = ?',
      [userId],
    );
    return result.isNotEmpty ? result.first['min_level'] as double? : null;
  }

  // Fetch the average blood sugar level for a user
  Future<double?> getAverageBloodSugar(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(level) AS avg_level FROM blood_sugar WHERE user_id = ?',
      [userId],
    );
    return result.isNotEmpty ? result.first['avg_level'] as double? : null;
  }

  // Fetch the maximum blood sugar level for a user
  Future<double?> getMaxBloodSugar(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MAX(level) AS max_level FROM blood_sugar WHERE user_id = ?',
      [userId],
    );
    return result.isNotEmpty ? result.first['max_level'] as double? : null;
  }

  // Fetch all blood sugar data for the distribution chart
  Future<List<Map<String, dynamic>>> getBloodSugarData(int userId) async {
    final db = await database;
    var result = await db.query(
      'blood_sugar',
      columns: ['level'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
    );
    return result;
  }

  Future<Map<String, int>> getBloodSugarFrequencies(int userId) async {
    final db = await database;

    // Define the ranges for the different categories
    final ranges = {
      'Rất thấp': [0, 55],
      'Thấp': [56, 70],
      'Tốt': [71, 130],
      'Cao': [131, 250],
      'Rất cao': [251, double.infinity],
    };

    // Create a map to store the frequencies
    final Map<String, int> frequencies = {
      'Rất thấp': 0,
      'Thấp': 0,
      'Tốt': 0,
      'Cao': 0,
      'Rất cao': 0,
    };

    // Query the database and count the occurrences for each range
    for (var range in ranges.entries) {
      final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM blood_sugar WHERE user_id = ? AND level BETWEEN ? AND ?',
        [userId, range.value[0], range.value[1]],
      )) ?? 0;
      frequencies[range.key] = count;
    }

    return frequencies;
  }

  // Insert blood pressure data into the blood_pressure table
  Future<int> insertBloodPressure(Map<String, dynamic> bloodPressure) async {
    final db = await database;
    return await db.insert('blood_pressure', bloodPressure);
  }

  // Fetch all blood pressure data for a user
  Future<List<Map<String, dynamic>>> getBloodPressureData(int userId) async {
    final db = await database;
    var result = await db.query(
      'blood_pressure',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getBloodPressureByUserId(int userId) async {
    final db = await database;
    return await db.query('blood_pressure', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
  }

  Future<Map<String, dynamic>?> getLatestBloodPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.query(
      'blood_pressure',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
      limit: 1,
    );

    if (result != null && result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Get minimum systolic blood pressure
  Future<double?> getMinSystolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT MIN(systolic) as minSystolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['minSystolic'] as double?;
    }
    return null;
  }

  // Get average systolic blood pressure
  Future<double?> getAverageSystolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT AVG(systolic) as avgSystolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['avgSystolic'] as double?;
    }
    return null;
  }

  // Get maximum systolic blood pressure
  Future<double?> getMaxSystolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT MAX(systolic) as maxSystolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['maxSystolic'] as double?;
    }
    return null;
  }

  // Get minimum diastolic blood pressure
  Future<double?> getMinDiastolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT MIN(diastolic) as minDiastolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['minDiastolic'] as double?;
    }
    return null;
  }

  // Get average diastolic blood pressure
  Future<double?> getAverageDiastolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT AVG(diastolic) as avgDiastolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['avgDiastolic'] as double?;
    }
    return null;
  }

  // Get maximum diastolic blood pressure
  Future<double?> getMaxDiastolicPressure(int userId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery(
        'SELECT MAX(diastolic) as maxDiastolic FROM blood_pressure WHERE user_id = ?',
        [userId]
    );
    if (result != null && result.isNotEmpty) {
      return result.first['maxDiastolic'] as double?;
    }
    return null;
  }

}
