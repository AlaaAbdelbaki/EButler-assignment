import 'package:ebutler/screens/client_locations/client_locations.mobile.dart';
import 'package:ebutler/screens/client_locations/client_locations.web.dart';
import 'package:ebutler/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

class ClientLocations extends StatelessWidget {
  const ClientLocations({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobilePage: ClientLocationsMobile(userId: userId),
      mdWebPage: ClientLocationsWeb(
        userId: userId,
      ),
    );
  }
}
