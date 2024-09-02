import 'package:chatgpt/injection.dart';

import '../models/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// StateNotifierProvider 是 Riverpod 里面提供的支持更复杂对象的 Provider 类型
// 为了使用 StateNotifierProvider，我需要构造一个StateNotifier对象
class MessageList extends StateNotifier<List<Message>> {
  MessageList() : super([]) { // 构造函数调用，初始化状态为一个空列表
    init();
  }

  // 初始化时,从数据库中获取所有的历史信息
  Future<void> init() async {
    state = await db.messageDao.findAllMessages();
  }

  // 更新当前状态
  void addMessage(Message message) {
    state = [...state, message];
  }

  // 接收SDK传来的部分消息数据
  // 若是新消息，插入列表最后
  // 若已存在该id，则将这两部分消息内容合并
  void upsertMessage(Message partialMessage) {
    final index = state.indexWhere((element) => element.id == partialMessage.id);
    var message = partialMessage;

    if (index >= 0) {
      final msg = state[index];
      message = partialMessage.copyWith(
        content: msg.content + partialMessage.content
      );
    }
    // update db
    db.messageDao.upsertMessage(message); // 消息插入数据库中

    if (index == -1) {
      state = [...state, message];
    } else {
      state = [...state]..[index] = message;
    }
  }
}

// 定义 messageProvider，方便在 UI 层读取到我们的状态
// 状态共享函数(ref)=> ....。该函数提供了一个ref变量，通过这个变量我们可以读取其他 provider 的状态
final messageProvider = StateNotifierProvider<MessageList, List<Message>>(
  (ref) => MessageList(),
);
