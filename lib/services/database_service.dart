import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'techtrack.db';
  static const int _dbVersion = 1;

  // Singleton
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Tabla de trabajos
    await db.execute('''
      CREATE TABLE jobs(
        id TEXT PRIMARY KEY,
        customerName TEXT NOT NULL,
        serviceDate TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        diagnosticFee REAL NOT NULL
      )
    ''');

    // Tabla de partes
    await db.execute('''
      CREATE TABLE parts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobId TEXT NOT NULL,
        partNumber TEXT NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (jobId) REFERENCES jobs (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de configuración
    await db.execute('''
      CREATE TABLE settings(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Insertar meta mensual por defecto
    await db.insert('settings', {'key': 'monthlyGoal', 'value': '5000'});
  }

  // ========== JOBS ==========

  static Future<List<Map<String, dynamic>>> getAllJobs() async {
    final db = await database;
    final jobs = await db.query('jobs', orderBy: 'serviceDate DESC');
    
    // Cargar partes para cada trabajo
    final result = <Map<String, dynamic>>[];
    for (var job in jobs) {
      final parts = await db.query('parts', where: 'jobId = ?', whereArgs: [job['id']]);
      result.add({...job, 'parts': parts});
    }
    return result;
  }

  static Future<void> insertJob(Map<String, dynamic> job, List<Map<String, dynamic>> parts) async {
    final db = await database;
    await db.insert('jobs', {
      'id': job['id'],
      'customerName': job['customerName'],
      'serviceDate': job['serviceDate'],
      'totalPrice': job['totalPrice'],
      'diagnosticFee': job['diagnosticFee'],
    });

    for (var part in parts) {
      await db.insert('parts', {
        'jobId': job['id'],
        'partNumber': part['partNumber'],
        'price': part['price'],
      });
    }
  }

  static Future<void> updateJob(String id, Map<String, dynamic> job, List<Map<String, dynamic>> parts) async {
    final db = await database;
    await db.update('jobs', {
      'customerName': job['customerName'],
      'serviceDate': job['serviceDate'],
      'totalPrice': job['totalPrice'],
      'diagnosticFee': job['diagnosticFee'],
    }, where: 'id = ?', whereArgs: [id]);

    // Eliminar partes antiguas e insertar nuevas
    await db.delete('parts', where: 'jobId = ?', whereArgs: [id]);
    for (var part in parts) {
      await db.insert('parts', {
        'jobId': id,
        'partNumber': part['partNumber'],
        'price': part['price'],
      });
    }
  }

  static Future<void> deleteJob(String id) async {
    final db = await database;
    await db.delete('parts', where: 'jobId = ?', whereArgs: [id]);
    await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  // ========== SETTINGS ==========

  static Future<double> getMonthlyGoal() async {
    final db = await database;
    final result = await db.query('settings', where: 'key = ?', whereArgs: ['monthlyGoal']);
    if (result.isNotEmpty) {
      return double.tryParse(result.first['value'] as String) ?? 5000;
    }
    return 5000;
  }

  static Future<void> setMonthlyGoal(double value) async {
    final db = await database;
    await db.update('settings', {'value': value.toString()}, where: 'key = ?', whereArgs: ['monthlyGoal']);
  }
}
