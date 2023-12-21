// ignore_for_file: unused_element

import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/features/admin/screens/admin_screen.dart';
import 'package:customer_taxi_booking_app/features/auth/screens/auth_screen.dart';
import 'package:customer_taxi_booking_app/features/auth/services/auth_service.dart';
import 'package:customer_taxi_booking_app/features/home/screens/home_screen.dart';
import 'package:customer_taxi_booking_app/firebase_options.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:customer_taxi_booking_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

  await Permission.notification.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.notification.request();
    }
  });

  await Permission.phone.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.phone.request();
    }
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthSerVice authSerVice = AuthSerVice();

  @override
  void initState() {
    super.initState();
    authSerVice.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Booking',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRooute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? Provider.of<UserProvider>(context).user.type == 'user'
              ? const HomeScreen()
              : const AdminScreen()
          : const AuthScreen(),
    );
  }
}
