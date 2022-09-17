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
    final otplist = <dynamic>[];
    for (var otp in orderList) {
      otplist.add(otp["OTP"]);
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
            itemBuilder: (ctx, i) => OrderPreviewItem(orderList[i]),
            // padding: const EdgeInsets.all(10),
            itemCount: orderList.length,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                print(otplist);
                print(distributorID);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Verification(otplist, orderList)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: kButtonColor),
              child: const Text('Enter OTP')),
        ])),
      ),
    );
  }
}

// class OrderPreviewItem extends StatelessWidget {
//   final String finalProductKey;
//   final Map finalProductMap;
//   const OrderPreviewItem(this.finalProductKey, this.finalProductMap, {Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: const Color(0xff764abc),
//           child: Text(finalProductKey),
//         ),
//         title: Text(finalProductMap[finalProductKey]["Quantity"].toString()),
//         subtitle: Text('Item description'),
//         trailing: Icon(Icons.more_vert),
//       ),
//     );
//   }
// }

// Normal Card
// return Card(
//   child: ListTile(
//     title: Text(finalProductKey),
//     subtitle: Text(finalProductMap[finalProductKey]["Quantity"].toString()),
//   ),
// );

class OrderPreviewItem extends StatelessWidget {
  // final String finalProductKey;
  final Map orderListItem;
  const OrderPreviewItem(this.orderListItem, {Key? key}) : super(key: key);

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
                      child: Text(orderListItem["ProductList"]["Name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      "(${orderListItem["ProductList"]["ProductID"]})",
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
                      orderListItem["ProductList"]["Quantity"].toString(),
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
                      orderListItem["ProductList"]["Description"].toString(),
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
