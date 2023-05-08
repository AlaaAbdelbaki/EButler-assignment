import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatWeb extends StatelessWidget {
  const ChatWeb({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: const [
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput()
          ],
        ),
      ),
    );
  }
}
