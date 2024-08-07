import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/chat_screen.dart';

void main() {
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