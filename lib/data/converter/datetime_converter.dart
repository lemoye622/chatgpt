// Datetime数据类型是不被 sqlite 支持的
// 创建一个转换器类，实现抽象的 TypeConverter 并提供内存对象类型和数据库类型作为参数类型。
// 该类继承了 decode() 和 encode() 函数，这些函数定义了从一个类型到另一个类型的转换。

import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMicrosecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}