import 'package:chatgpt/injection.dart';
import 'package:chatgpt/models/message.dart';
import 'package:chatgpt/states/chat_ui_state.dart';
import 'package:chatgpt/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:markdown_widget/config/all.dart';

// 如果想要获取 provider 状态，我们需要一个ref，这就需要我们在需要使用状态的地方用 HookConsumerWidget 包裹
// 修改 ChatScreen ，使其继承自HookConsumerWidget
// build 函数需要多加一个入参 WidgetRef ref
class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              // 聊天消息列表
              child: ChatMessageList(),
            ),
            // 输入框
            UserInputWidget(),
          ],
        ),
      ),
    );
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
            margin: const EdgeInsets.only(right: 48),
            child: MessageContentWidget(message: message),
          )
        )
      ],
    );
  }
}

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider); // 获取数据
    // useScrollController 是 Flutter Hooks 中的一个钩子
    // 这个钩子会创建一个ScrollController并且自动释放，这样我们就不需要自动管理了
    // ScrollController 用于控制 ListView 的滚动行为
    final listController = useScrollController();

    // ref.listen 用来监听 messageProvider 的变化。当消息列表发生变化时，它会触发回调函数
    // 在回调函数中，使用 Future.delayed 延迟 50 毫秒后，listController.jumpTo 会将列表滚动到最底部，确保新消息能够自动显示在视图中
    ref.listen(messageProvider, (previous, next) {
      Future.delayed(const Duration(milliseconds: 50), () {
        listController.jumpTo(
          listController.position.maxScrollExtent,
        );
      });
    });

    // 这里的ListView.separated是其中一个构造函数，其作用是能够动态地根据列表的数据大小动态生成组件
    // itemBuilder: 返回列表中每一个消息
    // separatorBuilder: 是用来返回分割线的，这里是直接使用内置的Divider
    // itemCount: 消息数量
    return ListView.separated(
      controller: listController,
      itemBuilder: (BuildContext context, int index) {
        return MessageItem(message: messages[index]);
      },
      separatorBuilder: (BuildContext context, int index) =>
        const Divider(
          height: 16,
        ),
      itemCount: messages.length,
    );
  }
}

class UserInputWidget extends HookConsumerWidget {
  const UserInputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUIState = ref.watch(chatUiProvider); // 获取网络请求状态
    // useTextEditingController 是一个 Flutter Hook
    // 用来创建和管理 TextEditingController，用于控制文本输入框的内容。
    final textController = useTextEditingController();

    return TextField(
      enabled: !chatUIState.requestLoading,
      // controller: 编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件
      controller: textController,
      // InputDecoration：用于控制TextField的外观显示，如提示文本、背景颜色、边框等
      decoration: InputDecoration(
        hintText: 'Type a message',
        suffixIcon: IconButton(
          onPressed: () {
            // 处理发送事件
            if (textController.text.isNotEmpty) {
              _sendMessage(ref, textController);
            }
          },
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }

  _sendMessage(WidgetRef ref, TextEditingController controller) {
    final content = controller.text;
    final message = Message(
      id: uuid.v4(), 
      content: content, 
      isUser: true, 
      timestamp: DateTime.now(),
    );
    // ref.read 来获取 provider 的引用，它不是响应式
    // 不要在build方法中使用 ref.read
    ref.read(messageProvider.notifier).upsertMessage(message); // 添加消息
    controller.clear();
    _requestChatGPT(ref, content);
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    ref.read(chatUiProvider.notifier).setRequestLoading(true);
    try {
      final id = uuid.v4();
      await chatgpt.streamChat(
        content,
        onSuccess: (text) {
          final message = Message(
            id: id, 
            content: text,
            isUser: false,
            timestamp: DateTime.now(),
          );
          ref.read(messageProvider.notifier).upsertMessage(message);
        },
      );
    } catch (err) {
      logger.e("requestChatGPT error: $err", error: err);
    } finally {
      ref.read(chatUiProvider.notifier).setRequestLoading(false);
    }
  }
}

class MessageContentWidget extends StatelessWidget {
  const MessageContentWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MarkdownGenerator().buildWidgets(message.content),
    );
  }
}