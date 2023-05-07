import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      ),
      child: SafeArea(
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
                    foregroundImage:
                        user == null ? null : NetworkImage('${user.photoURL}'),
                    radius: 20,
                  ),
                  title: Text('Welcome back ${user?.displayName}'),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .logout();
                    context.go('/login');
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
    );
  }
}
