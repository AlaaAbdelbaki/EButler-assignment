import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class ChatMobile extends StatelessWidget {
  const ChatMobile({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Scaffold(
        appBar: StreamChannelHeader(
          onImageTap: () {
            final String clientId = channel.state!.members
                .firstWhere(
                  (element) =>
                      element.user!.id !=
                      firebase_auth.FirebaseAuth.instance.currentUser!.uid,
                )
                .user!
                .id;
            context.push('/user-locations/$clientId');
          },
        ),
        body: Column(
          children: const [
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }
}
