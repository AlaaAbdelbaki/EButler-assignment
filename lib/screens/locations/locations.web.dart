import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/utils.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LocationsWeb extends StatefulWidget {
  const LocationsWeb({super.key});

  @override
  State<LocationsWeb> createState() => _LocationsWebState();
}

class _LocationsWebState extends State<LocationsWeb> {
  final MapController _controller = MapController();

  late Future<Position> _getLocationFuture;

  @override
  void initState() {
    super.initState();
    _getLocationFuture = determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? loggedInUser = context.watch<UserProvider>().user;

    return FutureBuilder<Position>(
      future: _getLocationFuture,
      builder: (context, snapshot) => snapshot.connectionState !=
              ConnectionState.done
          ? const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : FlutterMap(
              mapController: _controller,
              options: MapOptions(
                center: snapshot.hasData
                    ? LatLng(
                        snapshot.data!.latitude,
                        snapshot.data!.longitude,
                      )
                    : LatLng(
                        51.509364,
                        -0.128928,
                      ),
                zoom: 9.2,
                onTap: (tapPosition, point) async {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        final UserProvider userProvider =
                            Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        {
                          final GlobalKey<FormState> formKey =
                              GlobalKey<FormState>();
                          final TextEditingController titleController =
                              TextEditingController();
                          return Dialog(
                            child: SizedBox(
                              width: 600,
                              child: Form(
                                key: formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 20,
                                        ),
                                        child: Text(
                                          'Add a title to your location',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: TextFormField(
                                          controller: titleController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Title cannot be empty';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Add a title',
                                            prefixIcon: HeroIcon(
                                              HeroIcons.mapPin,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: AsyncButton(
                                          text: 'Add location',
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final Location location =
                                                  Location(
                                                title:
                                                    titleController.text.trim(),
                                                coordinates: point,
                                              );
                                              try {
                                                await userProvider
                                                    .addPosition(location);
                                                if (!mounted) return;
                                                context.pop();
                                              } catch (e) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Alert(
                                                    title:
                                                        'Error adding position',
                                                    content: '$e',
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: (loggedInUser?.positions ?? [])
                      .map(
                        (location) => Marker(
                          point: location.coordinates,
                          height: 600,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 100,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }
}
