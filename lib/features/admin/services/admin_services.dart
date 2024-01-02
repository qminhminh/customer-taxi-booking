// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:customer_taxi_booking_app/constants/error_handing.dart';
import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/constants/utils.dart';
import 'package:customer_taxi_booking_app/models/driver.dart';
import 'package:customer_taxi_booking_app/models/trip_request_model.dart';
import 'package:customer_taxi_booking_app/models/user.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
// get all drivers
  Future<List<UserDriver>> fecthAllDrivers(BuildContext context) async {
    List<UserDriver> list = [];
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/admin/fetchdrivers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              list.add(
                  UserDriver.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return list;
  }

  // get all customers
  Future<List<UserCustomer>> fecthAllCustomer(BuildContext context) async {
    List<UserCustomer> list = [];
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/admin/fetchcustomer'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              list.add(
                  UserCustomer.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return list;
  }

  // get all trip requets
  Future<List<TripRequest>> fetchAllTripRequest(BuildContext context) async {
    List<TripRequest> list = [];
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/admin/fetchtriprequest'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              list.add(
                  TripRequest.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return list;
  }

  // update block status driver
  void blockStatusDriver({
    required BuildContext context,
    required String id,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/admin/update-block-status/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Block driver successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // update block status customer
  void blockStatusCustomer({
    required BuildContext context,
    required String id,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/admin/update-block-status/customer'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Block cusomer successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // update unblock status driver
  void unBlockStatusDriver({
    required BuildContext context,
    required String id,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/admin/update-un-block-status/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "UnBlock Driver successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // update unblock status customer
  void unBlockStatusCustomer({
    required BuildContext context,
    required String id,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/admin/update-un-block-status/customer'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "UnBlock cusomer successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
