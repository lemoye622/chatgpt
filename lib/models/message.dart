class Message {
  final String id; // 唯一id
  final String content; // 消息的文本内容
  final bool isUser; // 标识消息是由用户发送还是由 ChatGPT 发送
  final DateTime timestamp; // 消息的发送时间

  Message(
      {required this.id, required this.content, required this.isUser, required this.timestamp});

  // 将Message对象转换为 JSON 格式（序列化）
  // 在Dart中，Map是一个键值对集合，其中每个键都映射到一个值
  // Map<String, dynamic>表示一个以字符串为键（String），以动态类型（dynamic）为值的映射
  Map<String, dynamic> toJson() => {
        'content': content,
        'isUser': isUser,
        'timestamp': timestamp
            .toIso8601String(), // 因为JSON格式原生不支持DateTime对象，因此需要将日期时间转换为可以被普遍理解并易于解析的字符串格式
      };

  // 从 JSON 数据中创建一个Message对象（反序列化）
  // 这是一个工厂构造函数，意味着它不必每次都创建新的实例（即不默认使用new关键字）；它有可能返回一个已存在的实例，尽管这里没有显示这样做
  // 使用场景：
  // （1）fromJson构造函数：用于根据传入的JSON数据创建对象实例。这是工厂构造函数常见的用途，特别是在模型类中处理来自外部数据源的数据时。
  // （2）控制实例创建：比如根据某个条件从一个已经存在的对象池中返回实例，或者根据不同的输入参数返回不同类型的对象。
  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json[
          'timestamp'])); // 从JSON映射中提取并解析timestamp字段。由于时间戳以ISO 8601字符串形式存储，使用DateTime.parse()将这个字符串转换回DateTime对象


  // Message的属性是不可改变的，为了方便我们处理数据，我们提供一新的函数copyWith
  // 所有参数皆是可选，用来修改部分属性到一个新的对象
  // 如果所有参数都为null，则是复制原来对象内容
  Message copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
  }) =>
      Message(
        id: id ?? this.id,
        content: content ?? this.content,
        isUser: isUser ?? this.isUser,
        timestamp: timestamp ?? this.timestamp,
      );
}
