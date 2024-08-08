import '../models/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// StateNotifierProvider 是 Riverpod 里面提供的支持更复杂对象的 Provider 类型
// 为了使用 StateNotifierProvider，我需要构造一个StateNotifier对象
class MessageList extends StateNotifier<List<Message>> {
  MessageList() : super([]); // 构造函数调用，初始化状态为一个空列表

  // 更新当前状态
  void addMessage(Message message) {
    state = [...state, message];
  }
}

// 定义 messageProvider，方便在 UI 层读取到我们的状态
// 状态共享函数(ref)=> ....。该函数提供了一个ref变量，通过这个变量我们可以读取其他 provider 的状态
final messageProvider = StateNotifierProvider<MessageList, List<Message>>(
  (ref) => MessageList(),
);
