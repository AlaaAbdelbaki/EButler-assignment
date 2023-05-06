import 'package:ebutler/screens/login/login.mobile.dart';
import 'package:ebutler/screens/login/login.web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constaints) {
        if (constaints.maxWidth < MOBILE_BREAKPOINT) {
          return const LoginMobile();
        }
        return const LoginWeb();
      },
    );
  }
}
