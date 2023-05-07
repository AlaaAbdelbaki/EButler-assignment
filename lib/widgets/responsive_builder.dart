import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobilePage,
    required this.mdWebPage,
    this.lgWebPage,
    this.xlWebPage,
    this.xxlWebPage,
  });

  final Widget mobilePage;
  final Widget mdWebPage;
  final Widget? lgWebPage;
  final Widget? xlWebPage;
  final Widget? xxlWebPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < MOBILE_BREAKPOINT) {
          return mobilePage;
        }
        if (constraints.maxWidth > MOBILE_BREAKPOINT &&
            constraints.maxWidth < WEB_MD) {
          return mdWebPage;
        }
        if (constraints.maxWidth > WEB_MD && constraints.maxWidth < WEB_LG) {
          return lgWebPage ?? mdWebPage;
        }
        if (constraints.maxWidth > WEB_MD && constraints.maxWidth < WEB_XL) {
          return xlWebPage ?? mdWebPage;
        }
        return xxlWebPage ?? mdWebPage;
      },
    );
  }
}
