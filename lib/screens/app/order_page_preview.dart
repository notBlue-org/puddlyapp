import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import '../../widget/cust_appbar.dart';
import 'package:driversapp/constants/colors.dart';

class OrderPreviewPage extends StatelessWidget {
  final List orderList;
  final String distributorID;
  final Map distributorMapItem;
  final Map allProductDetails;
  const OrderPreviewPage(this.orderList, this.distributorID,
      this.distributorMapItem, this.allProductDetails,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var finalProductList = <dynamic>{};
    for (var order in orderList) {
      order["ProductList"].forEach((product, quantBrand) => {
            finalProductList.add(product),
            if (allProductDetails.containsKey(product) &&
                allProductDetails[product]["Quantity"] != null)
              {allProductDetails[product]["Quantity"] += quantBrand[0]}
            else
              {allProductDetails[product]["Quantity"] = quantBrand[0]}
          });
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
            itemBuilder: (ctx, i) => OrderPreviewItem(
                finalProductList.elementAt(i), allProductDetails),
            // padding: const EdgeInsets.all(10),
            itemCount: finalProductList.length,
            scrollDirection: Axis.vertical,
          ),
          ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(backgroundColor: kButtonColor),
              child: const Text('Enter OTP')),
        ])),
      ),
    );
  }
}

class OrderPreviewItem extends StatelessWidget {
  final String finalProductKey;
  final Map finalProductMap;
  const OrderPreviewItem(this.finalProductKey, this.finalProductMap, {Key? key})
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
                      child: Text(finalProductMap[finalProductKey]["Name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      "($finalProductKey)",
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
                      finalProductMap[finalProductKey]["Quantity"].toString(),
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
                      finalProductMap[finalProductKey]["Description"]
                          .toString(),
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
