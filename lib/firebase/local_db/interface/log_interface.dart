import 'package:chaty_talk/models/log.dart';

abstract class LogInterface {
  openDb(dbName);

  init();

  addLog(LogModel logModel);

  // returns a list of logs
  Future<List<LogModel>> getLogs();

  deleteLogs(int logId);

  close();
}
