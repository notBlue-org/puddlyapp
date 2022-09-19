import 'package:driversapp/screens/app/otp_page.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import '../../widget/cust_appbar.dart';
import 'package:driversapp/constants/colors.dart';

class OrderPreviewPage extends StatelessWidget {
  final List orderList;
  final String distributorID;
  final Map distributorMapItem;
  const OrderPreviewPage(
      this.orderList, this.distributorID, this.distributorMapItem,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otpList = <dynamic>[];
    Map productMap = {};
    for (var order in orderList) {
      otpList.add(order["OTP"]);
      for (var product in order["ProductList"]) {
        if (productMap.containsKey(product["ProductID"])) {
          productMap[product["ProductID"]]["Quantity"] += product["Quantity"];
        } else {
          Map tempProductMap = {};
          tempProductMap["Description"] = product["Description"];
          tempProductMap["Name"] = product["Name"];
          tempProductMap["Quantity"] = product["Quantity"];
          tempProductMap["ProductID"] = product["ProductID"];
          productMap[product["ProductID"]] = tempProductMap;
        }
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Order Details"),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          SizedBox(
              height: 150,
              child: Stack(children: [Positioned(top: 0, child: WaveSvg())])),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, i) =>
                OrderPreviewItem(productMap.keys.toList()[i], productMap),
            // padding: const EdgeInsets.all(10),
            itemCount: orderList.length,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Verification(otpList, orderList)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: kButtonColor),
              child: const Text('Enter OTP')),
        ])),
      ),
    );
  }
}

class OrderPreviewItem extends StatelessWidget {
  final String productMapKey;
  final Map productMap;
  const OrderPreviewItem(this.productMapKey, this.productMap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(13, 21, 129, 0.03),
                    blurRadius: 100.0,
                    offset: Offset(0, 10.0),
                    spreadRadius: 2,
                  ),
                ]),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.2,
                      child: Text(productMap[productMapKey]["Name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      "(${productMap[productMapKey]["ProductID"]})",
                    ),
                    // SizedBox(width: 50),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Quantity: ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productMap[productMapKey]["Quantity"].toString(),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Desc: ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productMap[productMapKey]["Description"].toString(),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
