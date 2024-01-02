// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/admin/services/admin_services.dart';
import 'package:customer_taxi_booking_app/models/trip_request_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TripScreen extends StatefulWidget {
  static const String routeName = '/trip-admin';
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final AdminServices adminServices = AdminServices();
  List<TripRequest>? list;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final List<TripRequest> updatedList =
        await adminServices.fetchAllTripRequest(context);

    setState(() {
      list = updatedList;
      isLoading = false;
    });
  }

  launchGoogleMapFromSourceToDestination(
    pickUpLat,
    pickUpLng,
    dropOffLat,
    dropOffLng,
  ) async {
    String directionAPIUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$pickUpLat,$pickUpLng&destination=$dropOffLat,$dropOffLng&dir_action=navigate";

    if (await canLaunchUrl(Uri.parse(directionAPIUrl))) {
      await launchUrl(Uri.parse(directionAPIUrl));
    } else {
      throw "Could not lauch google map";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Customer'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: list == null
            ? const Loader()
            : ListView.builder(
                itemCount: list!.length,
                itemBuilder: (context, index) {
                  final listData = list![index];
                  if (listData.status != null && listData.status == "ended") {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      String? pickUpLat =
                                          listData.pickUpLatLng["latitude"];
                                      String? pickUpLng =
                                          listData.pickUpLatLng["longitude"];

                                      String? dropOffLat =
                                          listData.dropOffLatLng["latitude"];
                                      String? dropOffLng =
                                          listData.dropOffLatLng["longitude"];

                                      launchGoogleMapFromSourceToDestination(
                                        pickUpLat,
                                        pickUpLng,
                                        dropOffLat,
                                        dropOffLng,
                                      );
                                    },
                                    child: Text('View Detail'),
                                  ),
                                  Text(
                                    "Trip ID: " + listData.tripID,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "User Name: " + listData.userName,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Driver Name: " + listData.driverName,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Car Details: ${listData.carDetails['carColor']} ${listData.carDetails['carModel']} ${listData.carDetails['carNumber']}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Timing: " + listData.publishDateTime,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Fare: " + listData.fareAmount,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
      ),
    );
  }
}
