// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:ebutler/classes/locations.class.dart';
import 'package:intl_phone_field/phone_number.dart';

enum Role {
  OPERATOR,
  CUSTOMER,
}

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final PhoneNumber? phoneNumber;
  String? image;
  final Role? role;
  final List<Location>? positions;
  final String? operatorUid;
  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.role,
    this.positions,
    this.operatorUid,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    PhoneNumber? phoneNumber,
    Role? role,
    List<Location>? positions,
    String? operatorUid,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      positions: positions ?? this.positions,
      operatorUid: operatorUid ?? this.operatorUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': {
        'countryCode': phoneNumber?.countryCode,
        'number': phoneNumber?.number,
        'countryISOCode': phoneNumber?.countryISOCode,
      },
      'role': role?.name,
      'positions': positions
          ?.map(
            (e) => e.toMap(),
          )
          .toList(),
      'operatorUid': operatorUid
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] == null ? null : map['name'] as String,
      phoneNumber: map['phoneNumber'] == null
          ? null
          : PhoneNumber(
              countryCode: map['phoneNumber']['countryCode'] as String,
              number: map['phoneNumber']['number'] as String,
              countryISOCode: map['phoneNumber']['countryISOCode'] as String,
            ),
      role: map['role'] == null
          ? null
          : Role.values.firstWhere(
              (element) =>
                  element.name.toLowerCase() ==
                  (map['role'] as String).toLowerCase(),
            ),
      positions: map['locations'] == null
          ? null
          : List<Location>.from(
              (map['locations'] as List<dynamic>).map<Location>(
                (e) => Location.fromMap(e),
              ),
            ),
      operatorUid:
          map['operatorUid'] == null ? null : map['operatorUid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $uid, email: $email, name: $name, phoneNumber: $phoneNumber, role: ${role?.name}, positions: ${positions?.toString()}, operatorUid: $operatorUid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.positions == positions &&
        other.operatorUid == operatorUid;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        role.hashCode ^
        positions.hashCode ^
        operatorUid.hashCode;
  }
}
