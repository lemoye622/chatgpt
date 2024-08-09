// 该文件创建的目的在于统一管理各种服务的实例
// 这样在实例变更时会更方便 

import 'package:chatgpt/services/chatgpt_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

final chatgpt = ChatGPTService();

// 在我们的 App 中，我们希望只在开发模式下才打开 verbose 级别的日志，正常情况下（即生产环境中）是用 info 级别
// 这里我们就需要用到 Flutter 提供的一个变量kDebugMode
// VERBOSE：用于输出非常详细的调试信息，这些信息在生产中不太需要，但是会暴露我们代码实现的部分细节。这个版本中已弃用，使用 trace 代替
// INFO：用于输出重要的信息，例如应用程序启动、配置更改等
final logger = Logger(level: kDebugMode ? Level.trace : Level.info);

const uuid = Uuid();