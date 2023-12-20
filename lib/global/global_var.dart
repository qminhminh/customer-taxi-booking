import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;
String serverKeyFCM =
    "key=AAAAmAATbR8:APA91bHOprrPDzR_L_dQxd-UcYu2sufnCj0X_V-gdSVIF0G9pezWkKvFzlh9T_wNSiiJ_DMgrMbSOnQc6wz0xGxMbGxc-2tpXnIaiqyxptoSZbHzZwK-rKCcm960N_ESIakYfkBSh0mc";
String googleMapKey = "AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg";
// "AIzaSyDvSKI9ES_r3GzlR29FSwnaOZWxGLN93QQ";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(11.051855, 107.164392),
  zoom: 14.4746,
);

String pageName = "";
