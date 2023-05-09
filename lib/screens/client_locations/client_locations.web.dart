import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ClientLocationsWeb extends StatefulWidget {
  const ClientLocationsWeb({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<ClientLocationsWeb> createState() => _ClientLocationsWebState();
}

class _ClientLocationsWebState extends State<ClientLocationsWeb> {
  final MapController _controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Location>>(
          future: Provider.of<UserProvider>(context, listen: false)
              .getClientLocations(widget.userId),
          builder: (context, snapshot) => snapshot.connectionState !=
                  ConnectionState.done
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.hasError
                  ? Center(
                      child: Text('${snapshot.error}'),
                    )
                  : snapshot.data!.isEmpty
                      ? const Center(
                          child: Text(
                            'This user does not have any saved locations yet !',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : FlutterMap(
                          mapController: _controller,
                          options: MapOptions(
                            center: snapshot.hasData
                                ? LatLng(
                                    snapshot.data!.first.coordinates.latitude,
                                    snapshot.data!.first.coordinates.longitude,
                                  )
                                : LatLng(
                                    51.509364,
                                    -0.128928,
                                  ),
                            zoom: 9.2,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayer(
                              markers: (snapshot.data ?? [])
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
        ),
      ),
    );
  }
}
