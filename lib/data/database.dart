import 'dart:async';

import 'package:chatgpt/data/converter/datetime_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/message.dart';
import 'dao/message_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Message])
@TypeConverters([DateTimeConverter])
// 通过@TypeConverters注解添加给AppDatabase，完成sqlite对Datetime数据类型的支持
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
}