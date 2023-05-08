import 'dart:async';

import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/chat/chat.dart';
import 'package:ebutler/screens/complete_profile/complete_profile.dart';
import 'package:ebutler/screens/error/error_page.dart';
import 'package:ebutler/screens/home/home.dart';
import 'package:ebutler/screens/inbox/inbox.dart';
import 'package:ebutler/screens/locations/locations.dart';
import 'package:ebutler/screens/login/login.dart';
import 'package:ebutler/screens/register/register.dart';
import 'package:ebutler/screens/saloon/saloon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/chat',
  navigatorKey: _parentKey,
  refreshListenable:
      GoRouterRefreshListenable(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) {
    const String title = '';
    const String message = '';
    return const ErrorPage(title: title, message: message);
  },
  redirect: (context, state) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      if (state.location == '/login' || state.location == '/register') {
        return null;
      }
      return '/login';
    }
    try {
      final UserModel user =
          await Provider.of<UserProvider>(context, listen: false)
              .getUserDetails();
      if (user.name == null || user.phoneNumber == null || user.role == null) {
        return '/complete';
      }
    } catch (e) {
      await auth.signOut();
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/conversation/:id',
      builder: (context, state) {
        final String userId = state.pathParameters['id']!;

        return Chat(
          userId: userId,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/login',
      builder: (context, state) => const Login(),
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return null;
        }
        return '/chat';
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/register',
      builder: (context, state) => const Register(),
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return null;
        }
        return '/chat';
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/complete',
      builder: (context, state) => const CompleteProfile(),
      redirect: (context, state) async {
        final FirebaseAuth auth = FirebaseAuth.instance;
        if (auth.currentUser == null) return '/login';
        try {
          final UserModel user =
              await Provider.of<UserProvider>(context, listen: false)
                  .getUserDetails();
          if (user.name != null &&
              user.phoneNumber != null &&
              user.role != null) {
            return '/chat';
          }
        } catch (e) {
          await auth.signOut();
          return '/login';
        }
        return null;
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Home(
          child: child,
        );
      },
      navigatorKey: _shellKey,
      routes: [
        GoRoute(
          parentNavigatorKey: _shellKey,
          path: '/locations',
          builder: (context, state) => const Locations(),
          redirect: (context, state) {
            final UserModel? user = context.read<UserProvider>().user;
            return user?.role == Role.CUSTOMER ? null : '/saloon';
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellKey,
          path: '/chat',
          builder: (context, state) {
            return const Inbox();
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellKey,
          path: '/saloon',
          builder: (context, state) => const Saloon(),
          redirect: (context, state) {
            final UserModel? user = context.read<UserProvider>().user;
            return user?.role == Role.CUSTOMER ? '/locations' : null;
          },
        ),
      ],
    ),
  ],
);

GoRouter get router => _router;

class GoRouterRefreshListenable extends ChangeNotifier {
  GoRouterRefreshListenable(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
