// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/screens/app/success_page.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user_stored.dart';
import '../../widget/nav_bar.dart';
import 'package:intl/intl.dart';

class PaymentQR extends StatefulWidget {
  final List orderList;
  final String amountDue;
  final List map;
  final int finalCrate;

  const PaymentQR(this.orderList, this.amountDue, this.finalCrate, this.map,
      {Key? key})
      : super(key: key);

  @override
  State<PaymentQR> createState() => _PaymentQRState();
}

class _PaymentQRState extends State<PaymentQR> {
  @override
  Widget build(BuildContext context) {
    List orderList = widget.orderList;
    String amountDue = widget.amountDue;
    final List finalmap = widget.map;
    int finalCrate = widget.finalCrate;
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
        PaymentBody(orderList, amountDue, finalCrate, finalmap),
      ])),
    );
  }
}

class PaymentBody extends StatelessWidget {
  final List orderList;
  final String amountDue;
  final int finalCrate;
  final List finalmap;

  const PaymentBody(
      this.orderList, this.amountDue, this.finalCrate, this.finalmap,
      {Key? key})
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
            String amountReceived = "";
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
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Amount ',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("QR Payment"),
                      onPressed: () async {
                        // FlutterRingtonePlayer.play(
                        //
                        //     fromAsset: "assets/images/notif.wav");
                        DateTime now = DateTime.now();
                        final df = DateFormat('dd-MM-yy,hh-mm-ss');
                        final dfCrate = new DateFormat('dd-MM-yy,hh:mm');
                        var current = int.parse(finalMap[0]) +
                            (int.parse(finalMap[2]) - int.parse(finalMap[3]));
                        var data = {
                          "Outstanding": finalMap[0],
                          "DistributorID": finalMap[1],
                          "Given": finalMap[2],
                          "Recieved": finalMap[3],
                          "Current": current.toString()
                        };
                        FirebaseFirestore.instance
                            .collection("Crate_History")
                            .doc(dfCrate.format(now).toString())
                            .set(data);
                        var reciept =
                            FirebaseFirestore.instance.collection('Reciept');
                        reciept.doc(orderList[0]['OrderID']).set({
                          'Amount': amountReceived,
                          'Date': df.format(now).toString(),
                          'DistributorID': orderList[0]['DistributorID'],
                          'Instrument Date': "",
                          "Instrument No": "",
                          'Narration': "",
                          'OrderID': orderList[0]['OrderID'],
                          'Payment Mode': "UPI",
                        });

                        String newAmountDue = (double.parse(amountDue) -
                                double.parse(amountReceived))
                            .toString();
                        FirebaseFirestore.instance
                            .collection('Distributors')
                            .doc(orderList[0]['DistributorID'])
                            .update({
                              'AmountDue': newAmountDue,
                              'Crates': current.toString()
                            })
                            .then((value) =>
                                Misc.createSnackbar(context, "Amount updated"))
                            .catchError((error) => Misc.createSnackbar(
                                context, "Failed to update amount: $error"));
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
                              (value) => Misc.createSnackbar(context,
                                  "DocumentSnapshot successfully updated!"),
                              onError: (e) => Misc.createSnackbar(
                                  context, "Error updating document $e"));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor),
                    ),
                  ],
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
