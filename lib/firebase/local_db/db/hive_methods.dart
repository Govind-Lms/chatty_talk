import 'dart:io';

import 'package:chaty_talk/firebase/local_db/interface/log_interface.dart';
import 'package:chaty_talk/models/log.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveMethods implements LogInterface {
  // ignore: non_constant_identifier_names
  String hive_box = "";

  @override
  openDb(dbName) => (hive_box = dbName);

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLog(LogModel logModel) async {
    var box = await Hive.openBox(hive_box);

    var logMap = logModel.toMap(logModel);

    // box.put("custom_key", logMap);
    int idOfInput = await box.add(logMap);

    print("Log added with id ${idOfInput.toString()} in Hive db");

    close();

    return idOfInput;
  }

  updateLogs(int i, LogModel newLogModel) async {
    var box = await Hive.openBox(hive_box);

    var newLogMap = newLogModel.toMap(newLogModel);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  Future<List<LogModel>> getLogs() async {
    var box = await Hive.openBox(hive_box);

    List<LogModel> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);
      logList.add(LogModel.fromMap(logMap));
    }
    return logList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hive_box);

    await box.deleteAt(logId);
    // await box.delete(logId);
  }

  @override
  close() => Hive.close();
}
