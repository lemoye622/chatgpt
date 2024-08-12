import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id, // 唯一id
    required String content, // 消息的文本内容
    required bool isUser, // 标识消息是由用户发送还是由 ChatGPT 发送
    required DateTime timestamp, // 消息的发送时间
  }) = _Message;

   factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}
