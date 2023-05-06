import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/utils/extensions.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class CompleteProfileMobile extends StatefulWidget {
  const CompleteProfileMobile({super.key});

  @override
  State<CompleteProfileMobile> createState() => _CompleteProfileMobileState();
}

class _CompleteProfileMobileState extends State<CompleteProfileMobile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  PhoneNumber? _selectedPhoneNumber;
  Role? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Complete Profile',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: HeroIcon(
                        HeroIcons.user,
                      ),
                      hintText: 'Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: IntlPhoneField(
                    invalidNumberMessage: 'Invalid phone number',
                    onSaved: (phoneNumber) {
                      _selectedPhoneNumber = phoneNumber;
                    },
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
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
                    onChanged: (role) => setState(() {
                      _selectedRole = role!;
                    }),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
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
                          context.go('/');
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => const Alert(
                              title: 'Error',
                              content:
                                  'There was an error completing your profile',
                            ),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
