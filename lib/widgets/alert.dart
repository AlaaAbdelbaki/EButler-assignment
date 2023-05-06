import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Alert extends StatelessWidget {
  const Alert({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            'OK',
          ),
        ),
      ],
    );
  }
}
