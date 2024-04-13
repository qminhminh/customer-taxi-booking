import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;
String serverKeyFCM =
    "key=AAAAhlM0HqE:APA91bHwwKJ8IaWSKjuJlu_1ZTAp5c9bw9i7Vavn9zZsmol3rgF51cg6Cs8r-np2bKuZBGRsh-PeHpVDI6STAdamKMToy_gFfGY5oqybSJIIWi81iws1aAxpYbqWtaBCGHQqNg_raMMF";
String googleMapKey = "AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg";
// "AIzaSyDvSKI9ES_r3GzlR29FSwnaOZWxGLN93QQ";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(11.051855, 107.164392),
  zoom: 14.4746,
);

String pageName = "";
final audioPlayer = AssetsAudioPlayer();
