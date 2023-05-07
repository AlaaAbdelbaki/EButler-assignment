import 'package:ebutler/screens/home/home.mobile.dart';
import 'package:ebutler/screens/home/home.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobilePage: HomeMobile(
        child: child,
      ),
      mdWebPage: HomeWeb(
        child: child,
      ),
    );
  }
}
