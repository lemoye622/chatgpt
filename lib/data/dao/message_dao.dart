// 这个组件负责管理对底层 SQLite 数据库的访问
// 抽象类包含了查询数据库的方法签名，这些方法必须返回一个Future或Stream

import 'package:floor/floor.dart';

import '../../models/message.dart';

@dao
abstract class MessageDao {
  @Query('SELECT * FROM Message')
  Future<List<Message>> findAllMessages();

  @Query('SELECT * FROM Message WHERE id = :id')
  Future<Message?> findMessageById(String id);

  // onConflict：用来处理当数据发生冲突的时候用什么方式来处理
  // replace：用新数据替换旧数据并继续事务
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(Message message);

  @delete
  Future<void> deleteMessage(Message message);
}