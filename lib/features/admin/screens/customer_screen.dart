// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/admin/services/admin_services.dart';
import 'package:customer_taxi_booking_app/models/user.dart';
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
        title: Text('List customer'),
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
                        leading: listdata.photo == null
                            ? const CircleAvatar(
                                radius: 86,
                                backgroundImage:
                                    AssetImage("assets/images/avatar.png"),
                              )
                            : Image.network(
                                listdata.photo,
                                fit: BoxFit.fitHeight,
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
