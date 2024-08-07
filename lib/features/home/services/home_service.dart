// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:customer_taxi_booking_app/constants/error_handing.dart';
import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/constants/utils.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeService {
  double? lat;
  double? long;
  List<String> listtoken = [];
  String nameDriver = '';
  String photoDriver = '';
  String phoneNumberDriver = '';
  String idf = '';
  String status = '';
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('token');

  // get posion driver
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

  // add trip request
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

  // update status driver
  void updateNewStatus({
    required BuildContext context,
    required List<String> driverid,
    required String trip,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.put(
        Uri.parse('$uri/api/users/update-status/drivers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'driverid': driverid,
          'trip': trip,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Update new stutus");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// update drivce token
  upatedeviceToken({
    required BuildContext context,
  }) async {
    try {
      String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.put(
          Uri.parse('$uri/api/users/update-tokendevice/customer'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userprovider.user.token
          },
          body: jsonEncode({
            'email': userprovider.user.email,
            'devicetoken': deviceRecognitionToken,
            'uid': FirebaseAuth.instance.currentUser!.uid
          }));

      print(res.body);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            ref.set(deviceRecognitionToken);
            showSnackBar(context, 'Update device token');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// get Token Driver
  getTokenDrivers({
    required BuildContext context,
    required List<String> driverid,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/get-token/drivers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'uiddriver': driverid,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          try {
            List<dynamic> responseData = jsonDecode(res.body)['data'];
            listtoken.addAll(responseData.map((item) => item.toString()));

            print(listtoken);
          } catch (e) {
            print(e.toString());
          }
          print(listtoken);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get information driver in trip request
  getInfoDriverInTripRequest({
    required BuildContext context,
    required String tripID,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse(
            '$uri/api/users/get-information-in-trip-request/drivers/$tripID'),
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
            nameDriver = data['driverName'];
            photoDriver = data['driverPhoto'];
            phoneNumberDriver = data['driverPhone'];
            status = data['status'];
            idf = data['driverID'];
          } catch (e) {
            print(e.toString());
          }
          print(listtoken);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
