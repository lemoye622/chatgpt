import 'package:chatgpt/data/database.dart';
import 'package:chatgpt/injection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 要获取数据库的实例，请使用生成的$FloorAppDatabase类，它允许访问数据库构建器。名称由$Floor和数据库类名组成。
  // 传递给databaseBuilder()的字符串app_database是数据库文件名
  // 要初始化数据库，需要调用build()并确保等待结果，故而用到 await
  db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(
    // ProviderScope 是 Riverpod 的入口，也是必须要放在组件树（你想使用 Riverpod 组件的地方）的最底层
    // 这里我们是想在整个 App 都使用，所以放在runApp的入口
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}