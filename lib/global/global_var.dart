import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;
String serverKeyFCM =
    "key=AAAAOtdJJgY:APA91bH-Z6QUvSjLyib3NOQz6Cd9un5n_hc1V-sieT7Sll-BlvUYuax2ZJ0IANKVDuRwV0BCB-5tajde4f4NXGNybT7t8YfGbKxSeI4WXGInBiVAH4jqEAcVlk2tRxgZ-3hFYeTIxkCp";
String googleMapKey = "AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg";
// "AIzaSyDvSKI9ES_r3GzlR29FSwnaOZWxGLN93QQ";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(11.051855, 107.164392),
  zoom: 14.4746,
);

String pageName = "";
