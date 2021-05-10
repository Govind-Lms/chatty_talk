import 'dart:io';
import 'package:chaty_talk/firebase/local_db/interface/log_interface.dart';
import 'package:chaty_talk/models/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;

  String databaseName = "";

  String tableName = "Call_Logs";

  // columns
  String id = 'logId';
  String callerName = 'callerName';
  String callerPic = 'callerPic';
  String receiverName = 'receiverName';
  String receiverPic = 'receiverPic';
  String callStatus = 'callStatus';
  String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  @override
  openDb(dbName) => (databaseName = dbName);

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";

    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLog(LogModel logModel) async {
    var dbClient = await db;
    print("the log has been added in sqlite db");
    await dbClient.insert(tableName, logModel.toMap(logModel));
  }

  updateLogs(LogModel logModel) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      logModel.toMap(logModel),
      where: '$id = ?',
      whereArgs: [logModel.logId],
    );
  }

  @override
  Future<List<LogModel>> getLogs() async {
    try {
      var dbClient = await db;

      // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );

      List<LogModel> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(LogModel.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  deleteLogs(int logId) async {
    var client = await db;
    return await client
        .delete(tableName, where: '$id = ?', whereArgs: [logId + 1]);
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
