// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/admin/services/admin_services.dart';
import 'package:customer_taxi_booking_app/models/driver.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DriverScreen extends StatefulWidget {
  static const String routeName = '/driver-admin';
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final AdminServices adminServices = AdminServices();
  List<UserDriver>? list;
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

    final List<UserDriver> updatedList =
        await adminServices.fecthAllDrivers(context);

    setState(() {
      list = updatedList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Driver'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: list == null
            ? const Loader()
            : ListView.builder(
                itemCount: list!.length,
                itemBuilder: (context, index) {
                  final listData = list![index];
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            listData.photo == ''
                                ? const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/avatar.png"),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Điều này làm tròn góc ảnh
                                    child: Image.network(
                                      listData.photo,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit
                                          .cover, // Đảm bảo ảnh không bị méo khi thu nhỏ
                                    ),
                                  ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (listData.blockStatus == "no")
                                  TextButton(
                                    onPressed: () async {
                                      adminServices.blockStatusDriver(
                                          context: context, id: listData.idf);
                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child("drivers")
                                          .child(listData.idf)
                                          .update({
                                        "blockStatus": "yes",
                                      });
                                    },
                                    child: Text('Block'),
                                  ),
                                if (listData.blockStatus == "yes")
                                  TextButton(
                                    onPressed: () async {
                                      adminServices.unBlockStatusDriver(
                                          context: context, id: listData.idf);

                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child("drivers")
                                          .child(listData.idf)
                                          .update({
                                        "blockStatus": "no",
                                      });
                                    },
                                    child: Text('UnBlock'),
                                  ),
                                Text(
                                  "ID: " + listData.idf,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Name: " + listData.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Email:" + listData.email,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
