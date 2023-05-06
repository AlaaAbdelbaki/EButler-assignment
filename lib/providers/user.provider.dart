import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/services/user.services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> registerUserWithEmailAndPassword(
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

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserServices userServices = UserServices();
      await userServices.loginWithEmail(email, password);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Fetches the user details using the credentials found on the Fireauth instance
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
}
