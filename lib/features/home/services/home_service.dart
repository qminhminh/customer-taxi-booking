// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:customer_taxi_booking_app/constants/error_handing.dart';
import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/constants/utils.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeService {
  double? lat;
  double? long;

  void getPositionDriver({
    required BuildContext context,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/users/get-position/drivers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            try {
              dynamic data = jsonDecode(res.body);
              lat = data['lattitude'];
              long = data['longtitude'];

              showSnackBar(context, lat.toString());
            } catch (e) {
              print("gans faild");
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addTripREquest({
    required BuildContext context,
    required String tripID,
    required String publishDateTime,
    required String userName,
    required String userPhone,
    required String userID,
    required String latpick,
    required String longpick,
    required String latdrop,
    required String longdrop,
    required String pickUpAddress,
    required String dropOffAddress,
    required String driverID,
    required String latdriver,
    required String longdriver,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/trip-request/drivers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'tripID': tripID,
          'publishDateTime': publishDateTime,
          'userName': userName,
          'userPhone': userPhone,
          'userID': userID,
          'latpick': latpick,
          'longpick': longpick,
          'latdrop': latdrop,
          'longdrop': longdrop,
          'pickUpAddress': pickUpAddress,
          'dropOffAddress': dropOffAddress,
          'driverID': driverID,
          'latdriver': latdriver,
          'longdriver': longdriver
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Add Trip Request Success");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
