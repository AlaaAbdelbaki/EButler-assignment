import 'package:ebutler/screens/error/error.mobile.dart';
import 'package:ebutler/screens/error/error.web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < MOBILE_BREAKPOINT) {
          return ErrorMobile(
            title: title,
            message: message,
          );
        }
        return ErrorWeb(
          title: title,
          message: message,
        );
      },
    );
  }
}
