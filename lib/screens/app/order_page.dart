// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driversapp/screens/app/summary_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user_stored.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../widget/cust_appbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("My Orders"),
      body: Center(
          child: Column(children: [
        SizedBox(
            height: 150,
            child: Stack(children: [Positioned(top: 0, child: WaveSvg())])),
        const OrderPageBody(),
      ])),
    );
  }
}

class OrderPageBody extends StatelessWidget {
  const OrderPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future getRouteData() async {
      var distributorsOnRoute = <dynamic>{};
      var orderList = [];
      await FirebaseFirestore.instance
          .collection(Misc.getCurrentDate())
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc["Route"] == "1") {
            var orderMap = doc.data();
            distributorsOnRoute.add(doc["DistributorID"]);
            orderList.add(orderMap);
          }
        });
      });
      var distributorMap = {};
      for (var distributor in distributorsOnRoute) {
        await FirebaseFirestore.instance
            .collection('Distributors')
            .doc(distributor)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            distributorMap[distributor] = documentSnapshot.data();
          }
        });
      }

      return [distributorMap, orderList];
    }

    return FutureBuilder<dynamic>(
      future: getRouteData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          var distributorMap = snapshot.data[0];
          var orderList = snapshot.data[1];
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (ctx, i) => OrderItem(
                  distributorMapItem: distributorMap,
                  orderListItem: orderList[i]),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class OrderItem extends StatelessWidget {
  final Map distributorMapItem;
  final Map orderListItem;

  const OrderItem({
    Key? key,
    required this.distributorMapItem,
    required this.orderListItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(distributorMapItem["Status"]),
            Text(orderListItem["Status"]),
            Text(orderListItem["DistributorID"]),
            Text(orderListItem["Total Price"].toString()),
            Text(orderListItem["OTP"]),
            Text(orderListItem["PaymentType"]),
            Text(orderListItem["Route"]),
          ],
        ));
  }
}
