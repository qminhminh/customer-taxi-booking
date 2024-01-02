// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/admin/services/admin_services.dart';
import 'package:customer_taxi_booking_app/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  static const String routeName = '/customer-admin';
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final AdminServices adminServices = AdminServices();
  List<UserCustomer>? list;
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

    final List<UserCustomer> updatedList =
        await adminServices.fecthAllCustomer(context);

    setState(() {
      list = updatedList;
      isLoading = false;
    });
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
                                      adminServices.blockStatusCustomer(
                                          context: context, id: listData.idf);
                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child("users")
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
                                      adminServices.unBlockStatusCustomer(
                                          context: context, id: listData.idf);

                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child("users")
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
                                  "Email: " + listData.email,
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
