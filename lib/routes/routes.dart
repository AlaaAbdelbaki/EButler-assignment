import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/complete_profile/complete_profile.dart';
import 'package:ebutler/screens/error/error_page.dart';
import 'package:ebutler/screens/home/home.dart';
import 'package:ebutler/screens/login/login.dart';
import 'package:ebutler/screens/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  AppRouter();

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) {
      const String title = '';
      const String message = '';
      return const ErrorPage(title: title, message: message);
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
        redirect: (context, state) async {
          final FirebaseAuth auth = FirebaseAuth.instance;
          if (auth.currentUser == null) return '/login';
          try {
            final UserModel user =
                await Provider.of<UserProvider>(context, listen: false)
                    .getUserDetails();
            if (user.name == null ||
                user.phoneNumber == null ||
                user.role == null) {
              return '/complete';
            }
          } catch (e) {
            await auth.signOut();
            return '/login';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
        redirect: (context, state) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          if (auth.currentUser != null) return '/';
          return null;
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const Register(),
        redirect: (context, state) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          if (auth.currentUser != null) return '/';
          return null;
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
              return '/';
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
}
