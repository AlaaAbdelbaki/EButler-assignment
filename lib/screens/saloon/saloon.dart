import 'package:ebutler/screens/saloon/saloon.mobile.dart';
import 'package:ebutler/screens/saloon/saloon.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Saloon extends StatelessWidget {
  const Saloon({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: SaloonMobile(),
      mdWebPage: SaloonWeb(),
    );
  }
}
