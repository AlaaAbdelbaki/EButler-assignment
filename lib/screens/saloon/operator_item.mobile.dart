import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OperatorItemMobile extends StatelessWidget {
  const OperatorItemMobile({super.key, required this.operator});

  final UserModel operator;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(radius),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  foregroundImage: operator.image == null
                      ? null
                      : NetworkImage(operator.image!),
                  backgroundImage:
                      const AssetImage('assets/images/profile.jpeg'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text('${operator.name}'),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () => context.push('/conversation/${operator.uid}'),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
                ),
                child: const Text(
                  'Contact',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
