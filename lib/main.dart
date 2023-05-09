import 'package:ebutler/firebase_options.dart';
import 'package:ebutler/providers/system.provider.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/routes/routes.dart';
import 'package:ebutler/utils/utils.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Use emulators if running in debug mode
  // if (!kReleaseMode) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  // }

  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SystemProvider(),
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
          dividerColor: Colors.transparent,
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
        builder: (context, child) {
          return StreamChat(
            client: context.watch<SystemProvider>().client,
            child: child,
            onBackgroundEventReceived: (event) {
              if (event.type == 'message.new') {
                // Plays a sound when receiving a new message
                FlutterRingtonePlayer.playNotification();
              }
            },
          );
        },
        routerConfig: router,
      ),
    );
  }
}
