import 'dart:developer';

import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/screens/inbox/inbox.mobile.dart';
import 'package:ebutler/screens/inbox/inbox.web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class Inbox extends StatefulWidget {
  const Inbox({
    super.key,
  });

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  late Future<void> initRooms;
  @override
  void initState() {
    super.initState();
    initRooms = initChat();
  }

  @override
  Widget build(BuildContext context) {
    final StreamChatClient client = context.read<SystemProvider>().client;
    return FutureBuilder(
      future: initRooms,
      builder: (context, snapshot) =>
          snapshot.connectionState != ConnectionState.done
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : ResponsiveBuilder(
                  mobilePage: InboxMobile(
                    client: client,
                  ),
                  mdWebPage: InboxWeb(
                    client: client,
                  ),
                ),
    );
  }

  Future<void> initChat() async {
    final StreamChatClient client =
        Provider.of<SystemProvider>(context, listen: false).client;
    final User user = User(
      id: firebase_auth.FirebaseAuth.instance.currentUser!.uid,
      name: firebase_auth.FirebaseAuth.instance.currentUser!.displayName,
      image: firebase_auth.FirebaseAuth.instance.currentUser!.photoURL,
    );

    log(tokens[firebase_auth.FirebaseAuth.instance.currentUser!.uid]!);

    await client.connectUser(
      user,
      tokens[firebase_auth.FirebaseAuth.instance.currentUser!.uid]!,
    );
  }
}
