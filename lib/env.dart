import 'package:envied/envied.dart';

part 'env.g.dart';

//根据你的需要配置里面的字段
@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'HTTP_PROXY', defaultValue: '')
  static const String httpProxy = _Env.httpProxy;

  @EnviedField(varName: 'BASE_URL', defaultValue: '')
  static const String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'CHATGPT_MODEL')
  static const String chatGPTModel = _Env.chatGPTModel;
}