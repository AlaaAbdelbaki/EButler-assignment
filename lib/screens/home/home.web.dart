import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/utils/utils.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final UserModel? loggedInUser = context.watch<UserProvider>().user;
    final int currentIndex = context.watch<SystemProvider>().currentIndex;

    return Scaffold(
      floatingActionButton: loggedInUser?.role == Role.OPERATOR ||
              loggedInUser?.operatorUid != null
          ? null
          : FloatingActionButton(
              onPressed: currentIndex == 0
                  ? () async {
                      final List<UserModel> operators =
                          await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).getAllByRole(Role.OPERATOR);
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Contact an operator'),
                          content: DropdownButtonFormField<UserModel>(
                            items: operators
                                .map(
                                  (e) => DropdownMenuItem<UserModel>(
                                    value: e,
                                    child: Text('${e.name}'),
                                  ),
                                )
                                .toList(),
                            onChanged: (operator) async {
                              await Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).setOperatorUid(operator!.uid);
                              if (!mounted) return;
                              context.pop();
                              context.push('/conversation/${operator.uid}');
                            },
                          ),
                        ),
                      );
                    }
                  : () async {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) {
                            final UserProvider userProvider =
                                Provider.of<UserProvider>(
                              context,
                              listen: false,
                            );
                            {
                              final GlobalKey<FormState> formKey =
                                  GlobalKey<FormState>();
                              final TextEditingController titleController =
                                  TextEditingController();
                              return Dialog(
                                child: SizedBox(
                                  width: 600,
                                  child: Form(
                                    key: formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Text(
                                              'Add a title to your location',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: TextFormField(
                                              controller: titleController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Title cannot be empty';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: 'Add a title',
                                                prefixIcon: HeroIcon(
                                                  HeroIcons.mapPin,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: AsyncButton(
                                              text: 'Add location',
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  final Position
                                                      currentPosition =
                                                      await determinePosition();
                                                  final Location location =
                                                      Location(
                                                    title: titleController.text
                                                        .trim(),
                                                    coordinates: LatLng(
                                                      currentPosition.latitude,
                                                      currentPosition.longitude,
                                                    ),
                                                  );
                                                  try {
                                                    await userProvider
                                                        .addPosition(location);
                                                    if (!mounted) return;
                                                    context.pop();
                                                  } catch (e) {
                                                    if (!mounted) return;
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          Alert(
                                                        title:
                                                            'Error adding position',
                                                        content: '$e',
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
                          },
                        ),
                      );
                    },
              child: HeroIcon(
                currentIndex == 0 ? HeroIcons.pencilSquare : HeroIcons.mapPin,
                style: HeroIconStyle.solid,
              ),
            ),
      body: Stack(
        children: [
          // Main page content
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 300,
              height: MediaQuery.of(context).size.height,
              child: widget.child,
            ),
          ),
          // Sode nav bar
          SizedBox(
            width: 300,
            child: Material(
              elevation: 5,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: const AssetImage(
                                'assets/images/profile.jpeg',
                              ),
                              foregroundImage:
                                  user == null || user.photoURL == null
                                      ? null
                                      : NetworkImage('${user.photoURL}'),
                              radius: 20,
                            ),
                            title: Text('Welcome back ${user?.displayName}'),
                          ),
                        ),
                        ListTile(
                          leading: const HeroIcon(
                            HeroIcons.chatBubbleLeftRight,
                          ),
                          title: Text(
                            loggedInUser?.role == Role.CUSTOMER
                                ? 'Chat with us'
                                : 'Inbox',
                          ),
                          onTap: () {
                            Provider.of<SystemProvider>(
                              context,
                              listen: false,
                            ).setIndex(0);
                            context.go('/chat');
                          },
                        ),
                        loggedInUser?.role == Role.CUSTOMER
                            ? ListTile(
                                leading: const HeroIcon(HeroIcons.mapPin),
                                title: const Text('Locations'),
                                onTap: () {
                                  Provider.of<SystemProvider>(
                                    context,
                                    listen: false,
                                  ).setIndex(1);
                                  context.go('/locations');
                                },
                              )
                            : ListTile(
                                leading: const HeroIcon(HeroIcons.userGroup),
                                title: const Text('Saloon'),
                                onTap: () {
                                  Provider.of<SystemProvider>(
                                    context,
                                    listen: false,
                                  ).setIndex(1);
                                  context.go('/saloon');
                                },
                              ),
                      ],
                    ),
                    ListTile(
                      leading: const HeroIcon(
                        HeroIcons.arrowLeftOnRectangle,
                      ),
                      title: const Text('Logout'),
                      onTap: () async {
                        await Provider.of<UserProvider>(context, listen: false)
                            .logout();
                        if (!mounted) return;
                        context.go('/login');
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
