import 'dart:js';
import 'package:chatgpt/models/message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<Message> messages = [
    Message(content: "Hello", isUser: true, timestamp: DateTime.now()),
    Message(content: "How are you?", isUser: false, timestamp: DateTime.now()),
    Message(
        content: "Fine,Thank you. And you?",
        isUser: true,
        timestamp: DateTime.now()),
    Message(content: "I am fine.", isUser: false, timestamp: DateTime.now()),
  ];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext buildContext) {
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
                separatorBuilder: (BuildContext context, int index) => const Divider(
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
                      _sendMessage(_textController.text);
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

  _sendMessage(String content) {
    final message = Message(content: content, isUser: true, timestamp: DateTime.now());
    messages.add(message);
    _textController.clear();
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
      children: [
        CircleAvatar( // flutter提供的该组件用来专门处理头像问题，会把子组件直接切成圆形
          backgroundColor: message.isUser ? Colors.blue : Colors.grey,
          child: Text(
            message.isUser ? 'A' : 'GPT',
          ),
        ),
        const SizedBox( // 用来占用一定的空白
          width: 8,
        ),
        Text(message.content),
      ],
    );
  }
}