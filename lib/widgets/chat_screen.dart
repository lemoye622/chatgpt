import 'package:chatgpt/injection.dart';
import 'package:chatgpt/models/message.dart';
import 'package:chatgpt/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 如果想要获取 provider 状态，我们需要一个ref，这就需要我们在需要使用状态的地方用 HookConsumerWidget 包裹
// 修改 ChatScreen ，使其继承自HookConsumerWidge
// build 函数需要多加一个入参 WidgetRef ref
class ChatScreen extends HookConsumerWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider); // 获取数据
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Column 组建是不具备滚动能力的，我们需要使用 ListView 来创建一个可以滚动的列表，
        child: Column(
          children: [
            // Column 里面元素的高度是不做限制的，而 ListView 这种可以滚动的窗口又必须制定高度，这样就导致了报错
            // 我们在 ListView 外增加一个 Expanded 组件即可
            Expanded(
              // 这里的ListView.separated是其中一个构造函数，其作用是能够动态地根据列表的数据大小动态生成组件
              // itemBuilder: 返回列表中每一个消息
              // separatorBuilder: 是用来返回分割线的，这里是直接使用内置的Divider
              // itemCount: 消息数量
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return MessageItem(message: messages[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 16,
                ),
                itemCount: messages.length,
              ),
            ),
            TextField(
              // controller: 编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件
              controller: _textController,
              // InputDecoration：用于控制TextField的外观显示，如提示文本、背景颜色、边框等
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                  onPressed: () {
                    // 处理发送事件
                    if (_textController.text.isNotEmpty) {
                      _sendMessage(ref, _textController.text);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessage(WidgetRef ref, String content) {
    final message =
        Message(content: content, isUser: true, timestamp: DateTime.now());
    // ref.read 来获取 provider 的引用，它不是响应式
    // 不要在build方法中使用 ref.read
    ref.read(messageProvider.notifier).addMessage(message); // 添加消息
    _textController.clear();
    _requestChatGPT(ref, content);
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    final res = await chatgpt.sendChat(content);
    final text = res.choices.first.message?.content ?? '';
    final message = Message(content: text, isUser: false, timestamp: DateTime.now());
    ref.read(messageProvider.notifier).addMessage(message);
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          // flutter提供的该组件用来专门处理头像问题，会把子组件直接切成圆形
          backgroundColor: message.isUser ? Colors.blue : Colors.grey,
          child: Text(
            message.isUser ? 'A' : 'GPT',
          ),
        ),
        const SizedBox(
          // 用来占用一定的空白
          width: 8,
        ),
        // 要做下文字过长的处理，而 Text 的内容是不会换行的
        // 改成 Flexible 来处理
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text(message.content),
          )
        )
      ],
    );
  }
}