import 'package:Faleh_Hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:Faleh_Hafez/presentation/home/components/splash_page.dart';
import 'package:Faleh_Hafez/presentation/home/home_page.dart';
import 'package:Faleh_Hafez/presentation/themes/theme.dart';
import 'package:Faleh_Hafez/application/omen_list/omen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

void main() async {
  // initialize hive
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // setupLocator();

  // open box
  // ignore: unused_local_variable
  var box = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    void openBatteryOptimizationSettings() {
      if (Platform.isAndroid) {
        final intent = AndroidIntent(
          action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
        );
        intent.launch();
      }
    }

    @override
    void initState() {
      openBatteryOptimizationSettings();

      super.initState();
    }

    return FutureBuilder(
      //

      future: Future.delayed(
        const Duration(seconds: 3),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkTheme,
            home: const SplashPage(),
          );
        } else {
          //

          //! load menu page

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ThemeChangerBloc()..add(FirstTimeToOpenApp()),
              ),
              BlocProvider(
                create: (context) => OmenBloc(),
              ),
            ],
            child: BlocBuilder<ThemeChangerBloc, ThemeChangerState>(
              builder: (context, state) {
                if (state is ThemeChangerLoading) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: SplashPage(),
                  );
                }
                if (state is ThemeChangerLoaded) {
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: state.theme,
                      home: const HomePage());
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: darkTheme,
                    home: const SplashPage(),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
