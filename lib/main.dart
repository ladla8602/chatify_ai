import 'package:chatify_ai/firebase_options.dart';
import 'package:chatify_ai/lang/app_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/initial_bindings.dart';
import 'config/theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(ThemeController());
  Stripe.publishableKey = 'pk_test_51I8qeJLG0TY6E07fTqYQpf0uDbaIBREnGaWKT59jqjr33YE8UMLKTpCC3XRh23zwOnZ1JOSnZZdA8M0Jz3X3IYHD00GgaoWYzU';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get AuthController to determine the initial route
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.find<ThemeController>();
    // final LanguageController languageController = Get.put(LanguageController());

    return Obx(
      () => GetMaterialApp(
        enableLog: true,
        debugShowCheckedModeBanner: false,
        translationsKeys: AppTranslations.translationsKeys,
        locale: Get.deviceLocale, // Set default language
        // locale: languageController.getCurrentLanguage()?.locale,
        fallbackLocale: Locale('en', 'US'), // Fallback language
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ja', 'JP'),
          Locale('es', 'ES'),
          Locale('ar', 'AR'),
          Locale('ru', 'RU'),
        ],

        localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        initialBinding: InitialBindings(),
        initialRoute: authController.initialRoute,
        getPages: AppRoutes.pages,

        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode.value,
      ),
    );
  }
}
