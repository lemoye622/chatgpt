import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatUiState {
  final bool requestLoading; // 网络请求状态
  ChatUiState({
    this.requestLoading = false,
  });
}

class ChatUiStateProvider extends StateNotifier<ChatUiState> {
  ChatUiStateProvider() : super(ChatUiState());

  void setRequestLoading(bool requestLoading) {
    state = ChatUiState(requestLoading: requestLoading);
  }
}

final chatUiProvider = StateNotifierProvider<ChatUiStateProvider, ChatUiState>(
  (ref) => ChatUiStateProvider(),
);