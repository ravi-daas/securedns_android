// ignore_for_file: depend_on_referenced_packages, unused_local_variable
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/AuthRedirectController.dart';
import 'entities/ProfileImage.dart';
import 'main_view.dart';
import 'models/User.dart';
// import 'models/authentication/FirebaseAuthServiceModel.dart';
import 'models/authentication/AuthServiceModel.dart';
import 'providers/vpn_provider.dart';
// import 'views/auth_pages/forgot_password_page_view.dart';
import 'views/auth_pages/login_page_view.dart';
import 'utils/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();

// Check if the token is present and not expired
  bool tokenValid = await TokenManager.isTokenValid();

  // Set the initial route based on the token validity
  String initialRoute = tokenValid ? "/home" : "/";

  runApp(MyApp(initialRoute: initialRoute));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for base class instance of [FirebaseAuthServiceModel]
        Provider<AuthServiceModel>(
          create: (_) => AuthServiceModel(),
        ),
        // Provider for instance of UserModel
        Provider<UserData?>(
          create: (_) => AuthServiceModel().getUserDetails(),
        ),
        Provider<ProfileImage?>(
          create: (_) => ProfileImage(null),
        ),
        ChangeNotifierProvider<VpnState>(create: (context) => VpnState()),
      ],
      child: MaterialApp(
        title: 'Cygiene',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        routes: {
          "/": (context) => const AuthRedirectController(),
          "/login": (context) => const LoginPageView(),
          // "/forgotPassword": (context) => const ForgotPasswordView(),
          "/home": (context) => const MainView()
        },
      ),
    );
  }
}
