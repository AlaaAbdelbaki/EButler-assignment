import 'package:ebutler/screens/complete_profile/complete_profile.mobile.dart';
import 'package:ebutler/screens/complete_profile/complete_profile.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: CompleteProfileMobile(),
      mdWebPage: CompleteProfileWeb(),
    );
  }
}
