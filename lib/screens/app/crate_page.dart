import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/screens/app/payment_page.dart';
import 'package:driversapp/screens/app/payment_qr.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';

class Cratepage extends StatefulWidget {
  final List orderList;
  final String amountDue;
  const Cratepage(this.orderList, this.amountDue, {Key? key}) : super(key: key);

  @override
  State<Cratepage> createState() => _CratepageState();
}

class _CratepageState extends State<Cratepage> {
  @override
  Widget build(BuildContext context) {
    List orderList = widget.orderList;
    String amountDue = widget.amountDue;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Crate Management"),
      body: Center(
          child: Column(children: [
        SizedBox(
            height: 150,
            child: Stack(children: [Positioned(top: 0, child: WaveSvg())])),
        CratePagebody(orderList, amountDue),
      ])),
    );
  }
}

class CratePagebody extends StatefulWidget {
  final List orderList;
  final String amountDue;
  const CratePagebody(this.orderList, this.amountDue, {Key? key})
      : super(key: key);

  @override
  State<CratePagebody> createState() => _CratePagebodyState();
}

class _CratePagebodyState extends State<CratePagebody> {
  late String crateRem;

  late String _valuegiven = "";
  late String _valuereturned = "";
  @override
  void initState() {
    super.initState();
    crateRem = "";
    _valuegiven = "";
    _valuereturned = "";
  }

  @override
  Widget build(BuildContext context) {
    List orderList = widget.orderList;
    String amountDue = widget.amountDue;

    Future getCrate() async {
      Map<String, dynamic> map = {};
      await FirebaseFirestore.instance
          .collection("Distributors")
          .get()
          .then((QuerySnapshot querySnaphot) {
        for (var doc in querySnaphot.docs) {
          if (doc["DistributorID"] == orderList[0]["DistributorID"]) {
            var intialCrates = doc["Crates"];
            map.addEntries(
                [MapEntry(orderList[0]["DistributorID"], intialCrates)]);
          }
        }
      });

      return map;
    }

    return FutureBuilder<dynamic>(
      future: getCrate(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> finalMap = snapshot.data.cast<String, dynamic>();
          List<String> crates = [];

          finalMap.forEach((key, value) {
            crates.add(value);
          });
          var fincrates = crates[0];

          return Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width, // Full Width of Screen
              height: 500.0, // Desired Height
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Number of Crates to be Returned $fincrates  ',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 50.0),
                    const Text(
                      "Crates Given",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText:
                              'Number of Crates Given to the distributor by driver',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 192, 103, 103),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        _valuegiven = value;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Crates Returned",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText:
                              'Number of Crates Given back to  Driver by  Distributor',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 192, 103, 103),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        _valuereturned = value;
                      },
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                              color: kButtonColor,
                              child: const Text(
                                'Pay QR',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              onPressed: () {
                                if (_valuereturned == "") {
                                  Misc.createSnackbar(context,
                                      "Please enter the number of crates recieved");
                                  return;
                                }

                                int finalCrate = int.parse(_valuegiven) -
                                    int.parse(_valuereturned);
                                List finalmap = [
                                  fincrates,
                                  orderList[0]["DistributorID"],
                                  _valuegiven,
                                  _valuereturned
                                ];

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaymentQR(orderList,
                                        amountDue, finalCrate, finalmap)));
                              }),
                          MaterialButton(
                              color: kButtonColor,
                              child: const Text(
                                'Pay Cash',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              onPressed: () {
                                List finalmap = [
                                  fincrates,
                                  orderList[0]["DistributorID"],
                                  _valuegiven,
                                  _valuereturned
                                ];

                                if (_valuereturned == "") {
                                  Misc.createSnackbar(context,
                                      "Please enter the number of crates recieved");
                                  return;
                                }

                                int finalCrate = int.parse(_valuegiven) -
                                    int.parse(_valuereturned);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Payment(orderList,
                                        amountDue, finalCrate, finalmap)));
                              })
                        ])
                  ]));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
