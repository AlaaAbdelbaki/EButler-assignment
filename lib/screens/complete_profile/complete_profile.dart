import 'package:ebutler/screens/complete_profile/complete_profile.mobile.dart';
import 'package:ebutler/screens/complete_profile/complete_profile.web.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < MOBILE_BREAKPOINT) {
          return const CompleteProfileMobile();
        }
        return const CompleteProfileWeb();
      },
    );
  }
}
