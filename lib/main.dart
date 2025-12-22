import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

import 'fcm_functions.dart';
import 'src/global/services/dependencies.dart';
import 'src/global/views/pages.dart';
import 'src/src_barrel.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (GetPlatform.isMobile) {
    await fcmFunctions.initApp();
    await fcmFunctions.iosWebPermission();
    await AppDependency.init();
    fcmFunctions.listenToNotif(message);
    print("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  final wd = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wd);
  await GetStorage.init("detty");

  if (GetPlatform.isMobile) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await fcmFunctions.initApp();
    await fcmFunctions.iosWebPermission();
    fcmFunctions.foreGroundMessageListener();
  }
  await AppDependency.init();
  if (GetPlatform.isMobile) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // if (kReleaseMode) exit(1);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log('PlatformDispatcher.onError: $error');
    log(error.toString(), stackTrace: stack);
    return true;
  };
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...there was an error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(
            body: Center(child: error),
          );
        }

        ErrorWidget.builder = (errorDetails) {
          debugPrint(errorDetails.toString());
          return error;
        };
        if (widget != null) {
          return widget;
        }
        throw FlutterError('...widget is null...');
      },
      initialRoute: AppRoutes.home,
      title: 'Detty',
      getPages: AppPages.getPages,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryColorBackground,
          fontFamily: Assets.appFontFamily,
          primarySwatch: AppColors.primaryColor),
    );
  }
}
