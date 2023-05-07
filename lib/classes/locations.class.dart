// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class Location {
  String title;
  LatLng coordinates;
  Location({
    required this.title,
    required this.coordinates,
  });

  Location copyWith({
    String? title,
    LatLng? coordinates,
  }) {
    return Location(
      title: title ?? this.title,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      title: map['title'] as String,
      coordinates: LatLng(
        map['coordinates']['latitude'] as double,
        map['coordinates']['longitude'] as double,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(title: $title, coordinates: $coordinates)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.title == title && other.coordinates == coordinates;
  }

  @override
  int get hashCode => title.hashCode ^ coordinates.hashCode;
}
