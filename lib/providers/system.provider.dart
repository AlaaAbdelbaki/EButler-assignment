import 'package:ebutler/utils/env.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SystemProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final StreamChatClient _client = StreamChatClient(
    STREAM_KEY,
    logLevel: !kDebugMode ? Level.OFF : Level.ALL,
  );

  StreamChatClient get client => _client;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
