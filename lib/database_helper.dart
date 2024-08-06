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

    // If database doesn't exist, create it.
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_health_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE blood_sugar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        level REAL,
        date TEXT,
        time TEXT
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

  Future<List<Lesson>> getLessons() async {
    final db = await database;
    final res = await db.query('lessons');
    List<Lesson> list = res.isNotEmpty ? res.map((c) => Lesson.fromMap(c)).toList() : [];
    return list;
  }
}



