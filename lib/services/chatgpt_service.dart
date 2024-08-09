import 'package:chatgpt/env.dart';
import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
      config: OpenaiConfig(
      apiKey: Env.apiKey, // 你的apikey，这个是必填的
      baseUrl: Env.baseUrl, // 如果有自建OpenAI服务请设置这里，如果你自己的代理服务器不太稳定，这里可以配置为 https://openai.mignsin.workers.dev/v1
      // httpProxy: Env.httpProxy, // 代理服务地址，比如 clashx，你可以使用 http://127.0.0.1:7890
  ));

  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(
      model: Env.chatGPTModel, // chatgpt的哪种模型，默认是 GPT-3.5  Models.gpt3_5Turbo
      messages: [ // 发送给 OpenAI 后端的上下文
        ChatMessage(content: content, role: ChatMessageRole.user)
      ],
    );

    return await client.sendChatCompletion(request);
  }

  // 流式输出
  Future streamChat(
    String content, {
    Function(String text)? onSuccess,
  }) async {
    final request = ChatCompletionRequest(
        model: Env.chatGPTModel,
        stream: true, // 默认为false，这里设置为true，达到流式输出的效果
        messages: [ChatMessage(content: content, role: ChatMessageRole.user)],
    );

    return await client.sendChatCompletionStream(
      request, 
      onSuccess: (p0) {
        final text = p0.choices.first.delta?.content;
        if (text != null) {
          onSuccess?.call(text);
        }
      }
    );
  }
}
