import 'package:ebutler/screens/login/login.mobile.dart';
import 'package:ebutler/screens/login/login.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: LoginMobile(),
      mdWebPage: LoginWeb(),
    );
  }
}
