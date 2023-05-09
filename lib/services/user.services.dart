import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/interfaces/user.interface.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/phone_number.dart';

class UserServices implements IUserServices {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  UserServices()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _firebaseStorage = FirebaseStorage.instance;

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
      final Map<String, dynamic>? userJson = (await _firestore
              .collection('users')
              .doc('${_firebaseAuth.currentUser?.uid}')
              .get())
          .data();
      if (userJson == null) {
        return Future.error('Could not find user details');
      }
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
      await _firestore
          .collection('users')
          .doc('${_firebaseAuth.currentUser?.uid}')
          .update({
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

  /// Logs the user out of the application
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Uploads a photo to the firebase storage
  @override
  Future<void> uploadProfilePicture(String path) async {
    try {
      // creates a storage reference
      final Reference storageReference = _firebaseStorage.ref().child(
            '${_firebaseAuth.currentUser?.uid}/profilePicture.${path.split('/').last}',
          );
      // create a file from the path
      final File profilePicture = File(
        path,
      );
      // upload the file
      await storageReference.putFile(
        profilePicture,
        SettableMetadata(
          // Setting the file extension
          contentType: "image/${path.split('.').last}",
        ),
      );
      // get the download url after uploading
      final String downloadUrl = await storageReference.getDownloadURL();
      // saving the profile picture url to the Firebase auth user instance
      _firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'image': downloadUrl});
    } on FirebaseException catch (e, stackTrace) {
      log('Error uploading image', error: e, stackTrace: stackTrace);
      return Future.error((e).message!);
    } catch (e, stackTrace) {
      log('Error uploading image', error: e, stackTrace: stackTrace);
      return Future.error('Error uploading image');
    }
  }

  /// Same as [uploadProfilePicture] but for Web
  @override
  Future<void> uploadProfilePictureWeb(Uint8List file) async {
    try {
      // creates a storage reference
      final Reference storageReference = _firebaseStorage.ref().child(
            '${_firebaseAuth.currentUser?.uid}/profilePicture.png',
          );

      // create a buffer from the file
      // upload the file
      await storageReference.putData(
        file,
        SettableMetadata(
          // Setting the file extension
          contentType: 'image/png',
        ),
      );
      // get the download url after uploading
      final String downloadUrl = await storageReference.getDownloadURL();
      // saving the profile picture url to the Firebase auth user instance
      _firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'image': downloadUrl});
    } on FirebaseException catch (e, stackTrace) {
      log('$e');
      log('Error uploading image', error: e, stackTrace: stackTrace);
      return Future.error((e).message!);
    } catch (e, stackTrace) {
      log('$e');
      log('Error uploading image', error: e, stackTrace: stackTrace);
      return Future.error('Error uploading image');
    }
  }

  /// Adds a [position] to the user's saved positions
  @override
  Future<void> addPosition(Location location) async {
    try {
      await _firestore
          .collection('users')
          .doc('${_firebaseAuth.currentUser?.uid}')
          .update(
        {
          'locations': FieldValue.arrayUnion(
            [
              location.toMap(),
            ],
          )
        },
      );
    } on FirebaseException catch (e, stackTrace) {
      log('Error adding new position', error: e, stackTrace: stackTrace);
      return Future.error(e.message!);
    } catch (e, stackTrace) {
      log('Error adding new position', error: e, stackTrace: stackTrace);
    }
  }

  /// Fetches all users who have the OPERATOR [Role]
  @override
  Future<List<UserModel>> getAllByRole(Role role) async {
    try {
      final usersJson = (await _firestore
              .collection('users')
              .where(
                'role',
                isEqualTo: role.name,
              )
              .get())
          .docs;
      List<UserModel> users = [];
      for (var userJson in usersJson) {
        final UserModel user = UserModel.fromMap(userJson.data());
        if (!users.contains(user) &&
            user.uid != _firebaseAuth.currentUser!.uid) {
          users.add(user);
        }
      }
      return users;
    } on FirebaseException catch (e, stackTrace) {
      log('Error fetching users', error: e, stackTrace: stackTrace);
      return Future.error(e.message!);
    } catch (e, stackTrace) {
      log('Error fetching users', error: e, stackTrace: stackTrace);
      return Future.error(
        'Error fetching users',
      );
    }
  }

  /// Saves the Operator's uid to the user model to link each user with a unique operator
  @override
  Future<void> setOperatorUid(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update(
        {'operatorUid': uid},
      );
    } on FirebaseException catch (e) {
      return Future.error(e.message!);
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches the list of the client's saved locations
  @override
  Future<List<Location>> getClientLocations(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userJson = userDoc.data();
      if (userJson == null) {
        return Future.error('User not found !');
      }
      final UserModel user = UserModel.fromMap(userJson);
      return user.positions ?? [];
    } on FirebaseException catch (e) {
      log(
        'Error fetching user locations',
        error: e,
      );
      return Future.error(e.message!);
    }
  }
}
