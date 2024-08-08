import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: '', // 你的apikey，这个是必填的
      baseUrl: 'https://api.deepseek.com', // 如果有自建OpenAI服务请设置这里，如果你自己的代理服务器不太稳定，这里可以配置为 https://openai.mignsin.workers.dev/v1
      // httpProxy: '' // 代理服务地址，比如 clashx，你可以使用 http://127.0.0.1:7890
    )
  );

  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(
      model: 'deepseek-chat',  // chatgpt的哪种模型，默认是 GPT-3.5  Models.gpt3_5Turbo，我此处选用的是 DeepSeek 的 deepseek-chat 模型
      messages: [ // 发送给 OpenAI 后端的上下文
        ChatMessage(
          content: content,
          role: ChatMessageRole.user
        )
      ],
    );

    return await client.sendChatCompletion(request);
  }
}
