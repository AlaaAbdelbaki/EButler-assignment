import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/screens/saloon/operator_item.mobile.dart';
import 'package:ebutler/screens/saloon/operator_item.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class OperatorItem extends StatelessWidget {
  const OperatorItem({super.key, required this.operator});

  final UserModel operator;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobilePage: OperatorItemMobile(operator: operator),
      mdWebPage: OperatorItemWeb(operator: operator),
    );
  }
}
