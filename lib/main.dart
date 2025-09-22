import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SSLCommerzPayment());
  }
}

class SSLCommerzPayment extends StatefulWidget {
  const SSLCommerzPayment({super.key});

  @override
  State<SSLCommerzPayment> createState() => _SSLCommerzPaymentState();
}

class _SSLCommerzPaymentState extends State<SSLCommerzPayment> {
  double totalPrice = 100.00;

  void sslcommerzPayment() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "Digital Product",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: "9pmte68d133d6d9c03",
        store_passwd: "9pmte68d133d6d9c03@ssl",
        total_amount: totalPrice,
        tran_id: "TestTRX001",
      ),
    );

    final response = await sslcommerz.payNow();

    if (response.status == 'VALID') {
      print(jsonEncode(response));
      print('Payment completed, TRX ID: ${response.tranId}');
      print(response.tranDate);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment completed! TRX ID: ${response.tranId}'), backgroundColor: Colors.green));
    }

    if (response.status == 'Closed') {
      print('Payment closed');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment was closed'), backgroundColor: Colors.orange));
    }

    if (response.status == 'FAILED') {
      print('Payment failed');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment failed'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text('SSLCommerz Payment', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
              ),
              child: Column(
                children: [
                  Image.network('https://apps.odoo.com/web/image/loempia.module/193670/icon_image?unique=c301a64', height: 60, width: 60),
                  const SizedBox(height: 20),
                  const Text('SSLCommerz Payment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Amount: ৳${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: sslcommerzPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Pay with SSLCommerz',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
