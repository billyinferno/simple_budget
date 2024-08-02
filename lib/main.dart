import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_budget/router.dart';

void main() async {
  await runZonedGuarded(() async {
    // ensure widget already binding
    WidgetsFlutterBinding.ensureInitialized();

    // after that we can run the init app
    await Future.microtask(() async {
      // prefer to be portrait and up
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      // load the environment configuration
      debugPrint("Load .env files");
      await dotenv.load(fileName: "env/.dev.env"); 
    }).then((_) {
      // init finished
      debugPrint("💯 Initialization finished");

      // run the application
      runApp(const MyApp());
    }).onError((error, stackTrace) {
      debugPrint("Error when perform app init");
      debugPrint("Error: ${error.toString()}");
      debugPrintStack(stackTrace: stackTrace);
    },);
  },
  (error, stack) {
    debugPrint("Error: ${error.toString()}");
    debugPrintStack(stackTrace: stack);
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