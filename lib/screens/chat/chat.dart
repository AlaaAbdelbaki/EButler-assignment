import 'dart:developer';

import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/screens/chat/chat.mobile.dart';
import 'package:ebutler/screens/chat/chat.web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Chat extends StatefulWidget {
  const Chat({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Future<Channel> connectToChannelFuture;

  @override
  void initState() {
    super.initState();
    connectToChannelFuture = connectToChannel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Channel>(
      future: connectToChannelFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState != ConnectionState.done
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : snapshot.hasError
                  ? Text('${snapshot.error}')
                  : ResponsiveBuilder(
                      mobilePage: ChatMobile(
                        channel: snapshot.data!,
                      ),
                      mdWebPage: ChatWeb(
                        channel: snapshot.data!,
                      ),
                    ),
    );
  }

  Future<Channel> connectToChannel() async {
    try {
      final StreamChatClient client = context.read<SystemProvider>().client;

      try {
        final User user = User(
          id: firebase_auth.FirebaseAuth.instance.currentUser!.uid,
          name: firebase_auth.FirebaseAuth.instance.currentUser!.displayName,
          image: firebase_auth.FirebaseAuth.instance.currentUser!.photoURL,
        );
        await client.connectUser(
          user,
          tokens[firebase_auth.FirebaseAuth.instance.currentUser!.uid]!,
        );
      } catch (e) {
        log('User already connected');
      }

      final Channel channel = client.channel(
        'messaging',
        extraData: {
          'members': [
            firebase_auth.FirebaseAuth.instance.currentUser?.uid,
            widget.userId
          ]
        },
      );

      await channel.watch();
      return channel;
    } catch (e) {
      log('Error', error: e);
      return Future.error(e);
    }
  }
}
