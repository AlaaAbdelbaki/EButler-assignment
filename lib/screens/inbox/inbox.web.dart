import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class InboxWeb extends StatelessWidget {
  const InboxWeb({
    super.key,
    required this.client,
  });
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return StreamChannelListView(
      padding: const EdgeInsets.all(20),
      controller: StreamChannelListController(
        client: client,
        filter: Filter.in_(
          'members',
          [StreamChat.of(context).currentUser!.id],
        ),
      ),
      onChannelTap: (channel) {
        context.push(
          '/conversation/${channel.state!.members.firstWhere(
                (element) =>
                    element.user!.id !=
                    firebase_auth.FirebaseAuth.instance.currentUser!.uid,
              ).user!.id}',
        );
      },
    );
  }
}
