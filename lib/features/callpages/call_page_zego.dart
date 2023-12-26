import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String name;
  final String id;
  final String callID;
  const CallPage({
    Key? key,
    required this.callID,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          1800045999, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "61c1554e325beabaefa489f73edacb7f1b99711441ae5bb24919d3dc29663040", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: id,
      userName: name,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
