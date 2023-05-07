import 'package:ebutler/screens/register/register.mobile.dart';
import 'package:ebutler/screens/register/register.web.dart';

import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: RegisterMobile(),
      mdWebPage: RegisterWeb(),
    );
  }
}
