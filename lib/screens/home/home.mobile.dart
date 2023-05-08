import 'package:ebutler/classes/locations.class.dart';
import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/home/drawer.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/utils/utils.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = context.watch<SystemProvider>().currentIndex;
    final UserModel? loggedInUser = context.watch<UserProvider>().user;
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.black,
            ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          currentIndex == 1
              ? loggedInUser?.role == Role.CUSTOMER
                  ? 'My locations'
                  : 'Saloon'
              : 'Welome back ${loggedInUser?.name}',
          style: const TextStyle(color: Colors.black),
        ),
        actions: loggedInUser?.role == Role.OPERATOR
            ? null
            : [
                IconButton(
                  onPressed: () async {
                    final List<UserModel> operators =
                        await Provider.of<UserProvider>(context, listen: false)
                            .getAllByRole(Role.OPERATOR);
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (contetx) => AlertDialog(
                        title: const Text(
                          'Choose an operator',
                        ),
                        content: DropdownButtonFormField<UserModel>(
                          onChanged: (value) {
                            context.pop();
                            context.push('/conversation/${value?.uid}');
                          },
                          items: operators
                              .map(
                                (e) => DropdownMenuItem<UserModel>(
                                  value: e,
                                  child: Text(e.name!),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const HeroIcon(
                    HeroIcons.pencilSquare,
                  ),
                )
              ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          Provider.of<SystemProvider>(context, listen: false).setIndex(index);
          context.go(index == 0 ? '/chat' : '/locations');
        },
        items: loggedInUser?.role == Role.CUSTOMER
            ? [
                const BottomNavigationBarItem(
                  icon: HeroIcon(
                    HeroIcons.chatBubbleLeftRight,
                  ),
                  label: 'Chat with us',
                ),
                const BottomNavigationBarItem(
                  icon: HeroIcon(
                    HeroIcons.mapPin,
                  ),
                  label: 'Locations',
                ),
              ]
            : [
                const BottomNavigationBarItem(
                  icon: HeroIcon(
                    HeroIcons.inbox,
                  ),
                  label: 'Inbox',
                ),
                const BottomNavigationBarItem(
                  icon: HeroIcon(
                    HeroIcons.userGroup,
                  ),
                  label: 'Saloon',
                ),
              ],
      ),
      floatingActionButton: currentIndex == 0 ||
              loggedInUser?.role != Role.CUSTOMER
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final UserProvider userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (!mounted) return;
                final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                final TextEditingController titleController =
                    TextEditingController();
                await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if (value == null || value.isEmpty) {
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: AsyncButton(
                                text: 'Add location',
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    final Position currentLocation =
                                        await determinePosition();
                                    final Location location = Location(
                                      title: titleController.text.trim(),
                                      coordinates: LatLng(
                                        currentLocation.latitude,
                                        currentLocation.longitude,
                                      ),
                                    );
                                    try {
                                      await userProvider.addPosition(location);
                                      if (!mounted) return;
                                      context.pop();
                                    } catch (e) {
                                      if (mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (context) => Alert(
                                          title: 'Error adding position',
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
                    );
                  },
                );
              },
              child:
                  const HeroIcon(HeroIcons.mapPin, style: HeroIconStyle.solid),
            ),
      body: widget.child,
    );
  }
}
