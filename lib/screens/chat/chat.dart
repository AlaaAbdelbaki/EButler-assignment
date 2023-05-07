import 'package:ebutler/screens/chat/chat.mobile.dart';
import 'package:ebutler/screens/chat/chat.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: ChatMobile(),
      mdWebPage: ChatWeb(),
    );
  }
}
