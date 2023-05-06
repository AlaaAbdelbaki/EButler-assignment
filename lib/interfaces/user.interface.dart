import 'package:ebutler/models/user.model.dart';
import 'package:intl_phone_field/phone_number.dart';

abstract class IUserServices {
  Future<void> registerUserWithEmail(
    String email,
    String password,
  );

  Future<void> loginWithEmail(String email, String password);

  Future<UserModel> getUserDetails();

  Future<void> completeProfile(String name, PhoneNumber phoneNumber, Role role);
}
