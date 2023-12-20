import 'package:customer_taxi_booking_app/features/auth/screens/auth_screen.dart';
import 'package:customer_taxi_booking_app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRooute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.reouteName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());

    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text('Screen does not exit!')),
              ));
  }
}
