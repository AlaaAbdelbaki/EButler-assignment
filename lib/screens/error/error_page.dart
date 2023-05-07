import 'package:ebutler/screens/error/error.mobile.dart';
import 'package:ebutler/screens/error/error.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
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
    return ResponsiveBuilder(
      mobilePage: ErrorMobile(
        title: title,
        message: message,
      ),
      mdWebPage: ErrorWeb(
        title: title,
        message: message,
      ),
    );
  }
}
