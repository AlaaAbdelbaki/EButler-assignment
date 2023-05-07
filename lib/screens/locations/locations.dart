import 'package:ebutler/screens/locations/locations.mobile.dart';
import 'package:ebutler/screens/locations/locations.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class Locations extends StatelessWidget {
  const Locations({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobilePage: LocationsMobile(),
      mdWebPage: LocationsWeb(),
    );
  }
}
