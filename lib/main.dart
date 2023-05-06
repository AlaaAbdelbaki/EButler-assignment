import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/firebase_options.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/routes/routes.dart';
import 'package:ebutler/utils.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Use emulators if running in debug mode
  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MaterialApp.router(
        title: 'EButler',
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF0077b6)),
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    radius,
                  ),
                ),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  radius,
                ),
              ),
              maximumSize: const Size(
                double.infinity,
                50,
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        routerConfig: AppRouter().router,
      ),
    );
  }
}
