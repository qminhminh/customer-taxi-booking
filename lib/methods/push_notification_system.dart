// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, prefer_if_null_operators, unnecessary_null_comparison, duplicate_import

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:customer_taxi_booking_app/features/callpages/call_page_zego.dart';
import 'package:customer_taxi_booking_app/global/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;

  Future<String?> generateDeviceRegistrationToken() async {
    String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();

    DatabaseReference referenceOnlineDriver = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("token");

    referenceOnlineDriver.set(deviceRecognitionToken);

    firebaseCloudMessaging.subscribeToTopic("drivers");
    firebaseCloudMessaging.subscribeToTopic("users");
  }

  startListeningForNewNotification(BuildContext context) async {
    ///1. Terminated
    //When the app is completely closed and it receives a push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        audioPlayer.open(
          Audio("assets/audio/reng.mp3"),
        );

        audioPlayer.play();
        String idf = messageRemote.data["idf"];

        retrieveTripRequestInfo(idf, context);
      }
    });

    ///2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String idf = messageRemote.data["idf"];
        audioPlayer.open(
          Audio("assets/audio/reng.mp3"),
        );

        audioPlayer.play();

        retrieveTripRequestInfo(idf, context);
      }
    });

    ///3. Background
    //When the app is in the background and it receives a push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String idf = messageRemote.data["idf"];
        audioPlayer.open(
          Audio("assets/audio/reng.mp3"),
        );

        audioPlayer.play();

        retrieveTripRequestInfo(idf, context);
      }
    });
  }

  retrieveTripRequestInfo(String idf, BuildContext context) {
    audioPlayer.stop();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallPage(callID: idf, name: "You", id: idf)));
  }
}
