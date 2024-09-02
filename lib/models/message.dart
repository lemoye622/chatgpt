import 'package:floor/floor.dart';

// 注意 floor 和 freezed 不能够兼容，我们需要把 Message 类改造一下
@entity
class Message {
  @primaryKey
  final String id; // 唯一id
  final String content; // 消息的文本内容
  final bool isUser; // 标识消息是由用户发送还是由 ChatGPT 发送
  final DateTime timestamp; // 消息的发送时间
  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}


// 在 Dart 中，extension关键字可以用于创建扩展方法
// 这是一种在不修改原始类或创建子类的情况下向现有类添加方法的方式
// 扩展方法是一个静态方法，可以像实例方法一样使用，并且可以访问该类的私有变量和方法
// 使用扩展方法可以使代码更简洁和易于维护，同时也可以提高代码的可读性。
// 扩展方法必须定义在顶层，不能定义在类、函数或另一个扩展方法内部;扩展方法必须被命名，并且其名称必须反映它所扩展的类型;
// 扩展方法必须定义在与其扩展的类型相同的库中;扩展方法不能访问其扩展的类型的私有变量或方法
extension MessageExtension on Message {
  Message copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
