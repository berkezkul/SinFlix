import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/views/screens/login.dart';
import 'package:sinflix/views/screens/home.dart';
import 'package:sinflix/views/screens/register.dart';
import 'package:sinflix/views/screens/add_profile_photo.dart';
import 'package:sinflix/views/screens/profile.dart';
import 'package:sinflix/views/screens/movies.dart';
import 'package:sinflix/views/screens/splash.dart';
import 'utils/constants/theme.dart';
import 'utils/constants/routes.dart';
import 'services/navigation_service.dart';
import 'services/logger_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/generated/app_localizations.dart';
import 'blocs/language/language_bloc.dart';
import 'blocs/language/language_event.dart';
import 'blocs/language/language_state.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //logger service
  await logger.initialize();
  
  // Flutter'ın kendi splash'ini devre dışı bırakmak için
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );

  //Firebase Crashlytics & Analytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageBloc()..add(const LoadCurrentLanguage()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          Locale currentLocale = const Locale('tr', 'TR');
          
          if (state is LanguageLoaded) {
            currentLocale = state.locale;
          }
          
          return MaterialApp(
            title: 'SinFlix',
            theme: appTheme,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.instance.navigatorKey,
            
            // Dynamic locale
            locale: currentLocale,
            
            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Supported locales
            supportedLocales: const [
              Locale('tr', 'TR'), // Türkçe
              Locale('en', 'US'), // İngilizce
            ],
            
            routes: {
              AppRoutes.login: (context) => const LoginView(),
              AppRoutes.register: (context) => const RegisterView(),
              AppRoutes.profilePhoto: (context) => const ProfilePhotoView(),
              AppRoutes.home: (context) => const HomeView(),
              AppRoutes.profile: (context) => const ProfileView(),
              AppRoutes.movies: (context) => const MoviesView(),
            },
          );
        },
      ),
    );
  }
}