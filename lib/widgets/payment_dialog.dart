// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/features/star/service/star_service.dart';
import 'package:customer_taxi_booking_app/methods/common_methods.dart';
import 'package:customer_taxi_booking_app/features/star/screen/stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pay/pay.dart';

class PaymentDialog extends StatefulWidget {
  String fareAmount;
  String idf;
  String tripID;

  PaymentDialog({
    super.key,
    required this.fareAmount,
    required this.idf,
    required this.tripID,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  CommonMethods cMethods = CommonMethods();
  final StarService starService = StarService();
  double avgRating = 0;
  double myRating = 0;
  List<PaymentItem> paymentItems = [];

  @override
  void initState() {
    super.initState();

    paymentItems.add(
      PaymentItem(
        amount: widget.fareAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stars(
              rating: avgRating,
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.starColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  myRating = rating; // Update the state
                });
                starService.rateDriver(
                    context: context,
                    rating: rating,
                    idf: widget.idf,
                    tripID: widget.tripID);
              },
            ),
            const SizedBox(
              height: 21,
            ),
            const Text(
              "PAY CASH",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            const Divider(
              height: 1.5,
              color: Colors.black,
              thickness: 1.0,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "\$" + widget.fareAmount,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "This is fare amount ( \$ ${widget.fareAmount} ) you have to pay to the driver.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 31,
            ),
            ElevatedButton(
              onPressed: () {
                // GooglePayButton(
                //   onPressed: () => payPressed(address),
                //   // ignore: deprecated_member_use
                //   paymentConfigurationAsset: 'gpay.json',
                //   onPaymentResult: (){},
                //   paymentItems: paymentItems,
                //   height: 50,
                //   // style: GooglePayButtonStyle.black,
                //   type: GooglePayButtonType.buy,
                //   margin: const EdgeInsets.only(top: 15),
                //   loadingIndicator: const Center(
                //     child: CircularProgressIndicator(),
                //   ),
                // );
                Navigator.pop(context, "paid");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "PAY CASH",
              ),
            ),
            const SizedBox(
              height: 41,
            )
          ],
        ),
      ),
    );
  }
}
