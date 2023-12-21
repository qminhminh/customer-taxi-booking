// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/admin/services/admin_services.dart';
import 'package:customer_taxi_booking_app/models/driver.dart';
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
        title: Text('List drivers'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: list == null
            ? const Loader()
            : ListView.builder(
                itemCount: list!.length,
                itemBuilder: (context, index) {
                  final listdata = list![index];
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        leading: listdata.photo == ''
                            ? const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/avatar.png"),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Điều này làm tròn góc ảnh
                                child: Image.network(
                                  listdata.photo,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit
                                      .cover, // Đảm bảo ảnh không bị méo khi thu nhỏ
                                ),
                              ),
                        title: Text(
                          listdata.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          listdata.email,
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.horizontal_rule_outlined),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
