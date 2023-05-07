import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/chat/chat.dart';
import 'package:ebutler/screens/complete_profile/complete_profile.dart';
import 'package:ebutler/screens/error/error_page.dart';
import 'package:ebutler/screens/home/home.dart';
import 'package:ebutler/screens/locations/locations.dart';
import 'package:ebutler/screens/login/login.dart';
import 'package:ebutler/screens/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/chat',
  errorBuilder: (context, state) {
    const String title = '';
    const String message = '';
    return const ErrorPage(title: title, message: message);
  },
  navigatorKey: _parentKey,
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
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => Home(
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/locations',
          builder: (context, state) => const Locations(),
          redirect: (context, state) {
            final UserModel user = context.read<UserProvider>().user;
            return user.role == Role.CUSTOMER ? null : '/saloon';
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const Chat(),
        ),
      ],
    ),
    GoRoute(
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
  ],
);

GoRouter get router => _router;
