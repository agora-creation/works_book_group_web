import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/home.dart';
import 'package:works_book_group_web/screens/login.dart';
import 'package:works_book_group_web/screens/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDEFZJAaLCgi61WsXwZf-tZGA_aHH77flE",
      authDomain: "works-book.firebaseapp.com",
      projectId: "works-book",
      storageBucket: "works-book.appspot.com",
      messagingSenderId: "878999657230",
      appId: "1:878999657230:web:eb751d4e57df76428d155f",
      measurementId: "G-CX4T5R03RQ",
    ),
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (FirebaseAuth.instance.currentUser == null) {
    await Future.any([
      FirebaseAuth.instance.userChanges().firstWhere((e) => e != null),
      Future.delayed(const Duration(milliseconds: 3000)),
    ]);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.initialize()),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FluentLocalizations.delegate,
          SfGlobalLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja')],
        locale: const Locale('ja'),
        title: 'オシゴト予定帳 - 会社用',
        theme: customTheme(),
        home: const SplashController(),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return const HomeScreen();
      default:
        return const LoginScreen();
    }
  }
}
