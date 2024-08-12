import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_budget/_index.g.dart';

void main() async {
  await runZonedGuarded(() async {
    // ensure widget already binding
    WidgetsFlutterBinding.ensureInitialized();

    // after that we can run the init app
    await Future.microtask(() async {
      // prefer to be portrait and up
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      // load the environment configuration
      Log.info(message: "📦 Load .env files");
      await dotenv.load(fileName: "env/.prod.env"); 

      // initialize the local box
      Log.info(message: "📦 Init box");
      LocalStorage.init();
    }).then((_) {
      // init finished
      Log.success(message: "💯 Initialization finished");

      // run the application
      Log.success(message: "💯 Run application");
    }).onError((error, stackTrace) {
      Log.error(
        message: "❌ Error when perform app init",
        error: error,
        stackTrace: stackTrace
      );
    },);

    // run the app inside the run zone guarded instead
    runApp(const MyApp());
  },
  (error, stack) {
    Log.error(
      message: "❌ Error on runZoneGoarded",
      error: error,
      stackTrace: stack,
    );
  },);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return the router page
    return const RouterPage();
  }
}