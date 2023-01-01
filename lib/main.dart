import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/form_service.dart';
import 'services/message_service.dart';
import 'services/theme_service.dart';
import 'services/biometric_service.dart';
import 'services/internationalization_service.dart';
import 'services/localization_service.dart';
import 'widgets/screens/bouncer_widget.dart';
import 'widgets/screens/public/biometric_screen_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  //HiveLocalStorage.encryptionKey = dotenv.env["SUPABASE_SECURE_KEY"];
  await Supabase.initialize(
    url: kDebugMode
        ? dotenv.env['SUPABASE_URL_DEBUG']!
        : dotenv.env['SUPABASE_URL_PROD']!,
    anonKey: kDebugMode
        ? dotenv.env['SUPABASE_KEY_DEBUG']!
        : dotenv.env['SUPABASE_KEY_PROD']!,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => BiometricService()),
          ChangeNotifierProvider(create: (_) => InternationalizationService()),
          ChangeNotifierProvider(create: (_) => FormService()),
          ChangeNotifierProvider(create: (_) => MessageService()),
        ],
        child: Consumer3<ThemeService, InternationalizationService,
                BiometricService>(
            builder: (context,
                ThemeService theme,
                InternationalizationService internationalization,
                BiometricService localAuthentication,
                child) {
          return MaterialApp(
              theme: theme.darkTheme == true ? dark : light,
              locale: internationalization.locale,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('nl', ''),
              ],
              localizationsDelegates: const [
                LocalizationService.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => ResponsiveWrapper.builder(
                    BouncingScrollWrapper.builder(context, child!),
                    maxWidth: 1200,
                    minWidth: 450,
                    breakpoints: [
                      const ResponsiveBreakpoint.resize(450, name: MOBILE),
                      const ResponsiveBreakpoint.resize(800, name: TABLET),
                      const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                    ],
                    background: Container(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
              home: SafeArea(
                  child: Scaffold(
                      body: ((defaultTargetPlatform == TargetPlatform.iOS ||
                                  defaultTargetPlatform ==
                                      TargetPlatform.android) &&
                              (kDebugMode == false))
                          ? localAuthentication.biometrics == true
                              ? const BiometricScreenWidget()
                              : const BouncerWidget()
                          : const BouncerWidget())));
        }));
  }
}
