import 'dart:developer';

import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/utils/extensions.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class CompleteProfileWeb extends StatefulWidget {
  const CompleteProfileWeb({super.key});

  @override
  State<CompleteProfileWeb> createState() => _CompleteProfileWebState();
}

class _CompleteProfileWebState extends State<CompleteProfileWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  PhoneNumber? _selectedPhoneNumber;
  Role? _selectedRole;

  ValueKey imageKey = const ValueKey('image');

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(
          50,
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(radius),
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: 800,
                padding: const EdgeInsets.all(50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: 40,
                            ),
                            child: Text(
                              'Complete Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 60,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: () async {
                                await uploadImage();
                              },
                              child: Center(
                                child: CircleAvatar(
                                  key: imageKey,
                                  backgroundImage: const AssetImage(
                                    'assets/images/profile.jpeg',
                                  ),
                                  radius: 60,
                                  foregroundImage: FirebaseAuth
                                              .instance.currentUser!.photoURL ==
                                          null
                                      ? null
                                      : NetworkImage(
                                          '${FirebaseAuth.instance.currentUser?.photoURL}',
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                prefixIcon: HeroIcon(
                                  HeroIcons.user,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: IntlPhoneField(
                              onSaved: (number) => setState(() {
                                _selectedPhoneNumber = number;
                              }),
                              keyboardType: TextInputType.name,
                              invalidNumberMessage: 'Invalid phone number',
                              showDropdownIcon: false,
                              flagsButtonPadding: const EdgeInsets.only(
                                left: 10,
                              ),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              pickerDialogStyle: PickerDialogStyle(
                                width: 500,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'I am a :',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: DropdownButtonFormField<Role>(
                              onChanged: (role) {
                                setState(() {
                                  _selectedRole = role!;
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              value: _selectedRole,
                              items: Role.values
                                  .map(
                                    (role) => DropdownMenuItem<Role>(
                                      value: role,
                                      child: Text(
                                        role.name.capitalizeFirstLetter(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              validator: (role) {
                                if (role == null) {
                                  return 'Role cannot be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Select a role',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: AsyncButton(
                          text: 'Complete profile',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                await Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).completeProfile(
                                  _nameController.text.trim(),
                                  _selectedPhoneNumber!,
                                  _selectedRole!,
                                );
                                if (!mounted) return;
                                context.go('/chat');
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => Alert(
                                    title: 'Error logging in',
                                    content: '$e',
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (pickedFile == null) return;
    try {
      await userProvider.uploadProfilePicture(pickedFile.files.first.path!);
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      log('$e');
    }
    setState(() {
      imageKey = ValueKey('${DateTime.now().millisecondsSinceEpoch}');
    });
  }
}
