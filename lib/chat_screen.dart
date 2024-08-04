import 'dart:js';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
                  return Row(
                    children: [
                      const CircleAvatar(
                        child: Text('A'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Message $index"),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 16,
                ),
                itemCount: 100,
              ),
            ),
            TextField(
              // InputDecoration：用于控制TextField的外观显示，如提示文本、背景颜色、边框等
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}