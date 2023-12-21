import 'package:customer_taxi_booking_app/features/admin/bottombar/bottom_bar.dart';
import 'package:customer_taxi_booking_app/features/admin/screens/customer_screen.dart';
import 'package:customer_taxi_booking_app/features/admin/screens/driver_screen.dart';
import 'package:customer_taxi_booking_app/features/admin/screens/trip_screen.dart';
import 'package:customer_taxi_booking_app/features/auth/screens/auth_screen.dart';
import 'package:customer_taxi_booking_app/features/home/screens/home_screen.dart';
import 'package:customer_taxi_booking_app/features/search/screen/search_destination_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRooute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.reouteName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());

    case BottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomBar());

    case DriverScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const DriverScreen());

    case CustomerScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CustomerScreen());

    case TripScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const TripScreen());

    case SearchDestinationPage.reouteName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SearchDestinationPage());
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text('Screen does not exit!')),
              ));
  }
}
