import 'dart:async';

import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/interfaces/user.interface.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/services/user.services.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_field/phone_number.dart';

class UserProvider extends ChangeNotifier implements IUserServices {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  @override
  Future<void> registerUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      final UserServices userServices = UserServices();
      await userServices.registerUserWithEmail(
        email,
        password,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
    try {
      final UserServices userServices = UserServices();
      await userServices.loginWithEmail(email, password);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Fetches the user details using the credentials found on the Fireauth instance
  @override
  Future<UserModel> getUserDetails() async {
    try {
      final UserModel userModel = await UserServices().getUserDetails();
      setUser(userModel);
      return userModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Completes a user profile using the provided [name] [phoneNumber] and [role]
  @override
  Future<void> completeProfile(
    String name,
    PhoneNumber phoneNumber,
    Role role,
  ) async {
    try {
      await UserServices().completeProfile(name, phoneNumber, role);
      await getUserDetails();
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Uploads a profile picture to the storage using the provided [path]
  @override
  Future<void> uploadProfilePicture(String path) async {
    try {
      await UserServices().uploadProfilePicture(path);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Uploads a profile picture to the storage using the provided [path]
  @override
  Future<void> uploadProfilePictureWeb(Uint8List file) async {
    try {
      await UserServices().uploadProfilePictureWeb(file);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Logs out the user completely from the application
  @override
  Future<void> logout() async {
    await UserServices().logout();
    _user = null;
    notifyListeners();
  }

  /// Adds a position to a customer's favourites locations
  @override
  Future<void> addPosition(Location location) async {
    try {
      await UserServices().addPosition(location);
      await getUserDetails();
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Fetches the list of all users who have the OPERATOR [Role]
  @override
  Future<List<UserModel>> getAllByRole(Role role) async {
    try {
      final List<UserModel> operators = await UserServices().getAllByRole(role);
      return operators;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Assigns a provider to a Customer
  @override
  Future<void> setOperatorUid(String uid) async {
    try {
      await UserServices().setOperatorUid(uid);
      await getUserDetails();
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Fetches the Customer's locations
  @override
  Future<List<Location>> getClientLocations(String uid) async {
    try {
      return await UserServices().getClientLocations(uid);
    } catch (e) {
      return Future.error(e);
    }
  }
}
