import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/interfaces/user.interface.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/phone_number.dart';

class UserServices implements IUserServices {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserServices()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  /// Creates a new user in Firebase auth and saves their details in Firestore
  @override
  Future<void> registerUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      final UserCredential credentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        return Future.error('Could not get user details');
      }
      await _firestore.collection('users').doc(credentials.user!.uid).set(
        {
          'uid': credentials.user!.uid,
          'email': email,
        },
      );
    } catch (e, stackTrace) {
      log('Error in registerWithEmail', error: e, stackTrace: stackTrace);
      if (e is FirebaseException) {
        return Future.error(e.message!);
      }
    }
  }

  /// Logs in the user using the provided [email] and [password]
  @override
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, stackTrace) {
      log(
        'Error in login',
        error: e,
        stackTrace: stackTrace,
      );
      if (e is FirebaseAuthException) {
        return Future.error(
          e.message!,
        );
      }
    }
  }

  /// Fetches the user details from the server
  @override
  Future<UserModel> getUserDetails() async {
    try {
      final Map<String, dynamic> userJson = (await _firestore
              .collection('users')
              .limit(1)
              .where(
                'uid',
                isEqualTo: _firebaseAuth.currentUser!.uid,
              )
              .get())
          .docs
          .first
          .data();
      final UserModel userModel = UserModel.fromMap(userJson);
      return userModel;
    } catch (e, stackTrace) {
      log('Error in fetching user details', error: e, stackTrace: stackTrace);
      return Future.error(e);
    }
  }

  /// Completes the user profile using the provided details
  @override
  Future<void> completeProfile(
    String name,
    PhoneNumber phoneNumber,
    Role role,
  ) async {
    try {
      QueryDocumentSnapshot document = (await _firestore
              .collection('users')
              .limit(1)
              .where(
                'uid',
                isEqualTo: _firebaseAuth.currentUser!.uid,
              )
              .get())
          .docs
          .first;
      await _firestore.collection('users').doc(document.id).update({
        'name': name,
        'phoneNumber': {
          'countryCode': phoneNumber.countryCode,
          'number': phoneNumber.number,
          'countryISOCode': phoneNumber.countryISOCode,
        },
        'role': role.name,
      });
      await _firebaseAuth.currentUser!.updateDisplayName(name);
    } catch (e, stackTrace) {
      log(
        'Error completing profile',
        error: e,
        stackTrace: stackTrace,
      );
      return Future.error(e);
    }
  }
}
