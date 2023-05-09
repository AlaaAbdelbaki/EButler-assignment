import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserProvider>().user;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: const AssetImage(
                        'assets/images/profile.jpeg',
                      ),
                      foregroundImage: user == null || user.image == null
                          ? null
                          : NetworkImage(
                              '${FirebaseAuth.instance.currentUser?.photoURL}',
                            ),
                      radius: 20,
                    ),
                    title: Text('Welcome back ${user?.name}'),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () async {
                      Provider.of<SystemProvider>(context, listen: false)
                          .setIndex(0);
                      await Provider.of<UserProvider>(context, listen: false)
                          .logout();
                    },
                    leading: const HeroIcon(
                      HeroIcons.arrowLeftOnRectangle,
                    ),
                    title: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
