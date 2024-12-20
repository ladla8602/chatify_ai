import 'package:chatify_ai/firebase_options.dart';
import 'package:chatify_ai/lang/app_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'bindings/initial_bindings.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get AuthController to determine the initial route
    final AuthController authController = Get.find<AuthController>();
    return GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: false,
      translationsKeys: AppTranslations.translationsKeys,
      locale: Get.deviceLocale, // Set default language
      fallbackLocale: Locale('en', 'US'), // Fallback language
      supportedLocales: [
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialBinding: InitialBindings(),
      initialRoute: authController.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
