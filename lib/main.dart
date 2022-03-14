import 'package:covi_kill/models/levels_manager.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:covi_kill/screens/home.dart';
import 'package:covi_kill/screens/levels.dart';
import 'package:covi_kill/screens/splash_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

Future<void> main() async {

  debugPrintGestureArenaDiagnostics = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsManager()),
          ChangeNotifierProvider(create: (context) => LevelsManager()),
        ],
      child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
          ),
        title: 'Covi Kill',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScrenn(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/level': (context) => const LevelsScreen()
        }
      ),
    );
  }
}