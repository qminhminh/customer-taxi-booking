// ignore_for_file: unnecessary_import, unused_local_variable, sized_box_for_whitespace, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:customer_taxi_booking_app/features/auth/services/auth_service.dart';
import 'package:customer_taxi_booking_app/features/search/screen/search_destination_page.dart';
import 'package:customer_taxi_booking_app/global/global_var.dart';
import 'package:customer_taxi_booking_app/methods/common_methods.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String reouteName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double bottomMapPadding = 0;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 276;
  final AuthSerVice authSerVice = AuthSerVice();

// style map
  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/night_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

// get current positon
  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await getUserInfoAndCheckBlockStatus();
  }

  // check block status
  getUserInfoAndCheckBlockStatus() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        } else {
          FirebaseAuth.instance.signOut();

          authSerVice.logOut(context);

          cMethods.displaySnackBar(
              "you are blocked. Contact admin: alizeb875@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        authSerVice.logOut(context);
      }
    });
  }

//============================================================================================
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.black87,
        child: Drawer(
          backgroundColor: Colors.white10,
          child: ListView(
            children: [
              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              //header
              Container(
                color: Colors.black54,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                  ),
                  child: Row(
                    children: [
                      userProvider.photo == ''
                          ? Image.asset(
                              "assets/images/avatar.png",
                              width: 60,
                              height: 60,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Điều này làm tròn góc ảnh
                              child: Image.network(
                                userProvider.photo,
                                width: 20,
                                height: 20,
                                fit: BoxFit
                                    .cover, // Đảm bảo ảnh không bị méo khi thu nhỏ
                              ),
                            ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              const SizedBox(
                height: 10,
              ),

              //body
              ListTile(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                ),
                title: const Text(
                  "About",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();

                  authSerVice.logOut(context);
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ///=================================================google map==============
          GoogleMap(
            padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              updateMapTheme(controllerGoogleMap!);

              googleMapCompleterController.complete(controllerGoogleMap);

              setState(() {
                bottomMapPadding = 300;
              });

              getCurrentLiveLocationOfUser();
            },
          ),

          ///=============================drawer button===============
          Positioned(
            top: 36,
            left: 19,
            child: GestureDetector(
              onTap: () {
                sKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          ///search location icon button
          Positioned(
            left: 0,
            right: 0,
            bottom: -80,
            child: Container(
              height: searchContainerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => SearchDestinationPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
