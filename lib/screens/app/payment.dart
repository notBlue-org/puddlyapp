import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/screens/app/store_page.dart';
import 'package:driversapp/screens/app/success_page.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_stored.dart';
import '../../widget/nav_bar.dart';

class Payment extends StatefulWidget {
  final List orderList;
  final String amountDue;
  const Payment(this.orderList, this.amountDue, {Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Widget build(BuildContext context) {
    List orderList = widget.orderList;
    String amountDue = widget.amountDue;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Payment Page"),
      body: Center(
          child: Column(children: [
        SizedBox(
            height: 150,
            child: Stack(children: [Positioned(top: 0, child: WaveSvg())])),
        PaymentBody(orderList, amountDue),
      ])),
    );
  }
}

class PaymentBody extends StatelessWidget {
  final List orderList;
  final String amountDue;

  const PaymentBody(this.orderList, this.amountDue, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future getQR() async {
      final userBox = await Hive.openBox<UserStore>('user');
      final driverRoute = userBox.getAt(0)?.route;
      final driverName = userBox.getAt(0)?.username;
      List<String> map = [];
      await FirebaseFirestore.instance
          .collection("Drivers")
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["Name"] == driverName && doc["Route"] == driverRoute) {
            var name = doc["Name"];
            var qr = doc["QR"];
            map.add(name);
            map.add(qr);
          }
        }
      });

      return map;
    }

    return FutureBuilder<dynamic>(
        future: getQR(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<String> finalMap = snapshot.data.cast<String>();
            String imageUrl = finalMap[1];
            // print(orderList[0]['DistributorID']);
            var amountReceived;
            // String name = finalMap[0];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                  width: 50,
                ),
                Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 25,
                  width: 25,
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      onChanged: (value) {
                        amountReceived = value;
                        print(amountReceived);
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Amount ',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Confirm Order"),
                  onPressed: () async {
                    double newAmountDue =
                        double.parse(amountDue) - double.parse(amountReceived);
                    FirebaseFirestore.instance
                        .collection('Distributors')
                        .doc(orderList[0]['DistributorID'])
                        .update({'AmountDue': newAmountDue})
                        .then((value) => print("Amount Updated"))
                        .catchError((error) =>
                            print("Failed to update amount: $error"));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuccessPage()),
                    );

                    for (var order in orderList) {
                      final statusUpdateRef = FirebaseFirestore.instance
                          .collection(order["CollectionName"])
                          .doc(order["OrderID"]);
                      statusUpdateRef.update({"Status": "Delivered"}).then(
                          (value) =>
                              print("DocumentSnapshot successfully updated!"),
                          onError: (e) => print("Error updating document $e"));
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: kButtonColor),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
