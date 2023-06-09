import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_field/phone_number.dart';

abstract class IUserServices {
  Future<void> registerUserWithEmail(
    String email,
    String password,
  );

  Future<void> loginWithEmail(String email, String password);

  Future<UserModel> getUserDetails();

  Future<void> completeProfile(String name, PhoneNumber phoneNumber, Role role);

  Future<void> logout();

  Future<void> uploadProfilePicture(String path);

  Future<void> uploadProfilePictureWeb(
    Uint8List file,
  );

  Future<void> addPosition(Location location);

  Future<List<UserModel>> getAllByRole(Role role);

  Future<void> setOperatorUid(String uid);

  Future<List<Location>> getClientLocations(String uid);
}
