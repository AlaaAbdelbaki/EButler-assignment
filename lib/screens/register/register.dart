import 'package:ebutler/screens/register/register_mobile.dart';
import 'package:ebutler/screens/register/register_web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, breakpoints) {
        if (breakpoints.maxWidth < MOBILE_BREAKPOINT) {
          return const RegisterMobile();
        }
        return const RegisterWeb();
      },
    );
  }
}
