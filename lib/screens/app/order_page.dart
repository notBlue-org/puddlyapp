// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driversapp/screens/app/summary_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user_stored.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../widget/cust_appbar.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      var distToOrderMap = {};
      final userBox = await Hive.openBox<UserStore>('user');
      final driverRoute = userBox.getAt(0)?.route;
      await FirebaseFirestore.instance
          .collection(Misc.getCurrentDate())
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["Route"] == driverRoute) {
            var distributor = doc["DistributorID"];
            distributorsOnRoute.add(distributor);
            // DateTime nowFiveDaysAgo = DateTime.now().add(Duration(days: -5));
            if (distToOrderMap.containsKey(distributor)) {
              distToOrderMap[distributor].add(doc.data());
            } else {
              distToOrderMap[distributor] = [doc.data()];
            }
          }
        }
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

      return [distributorMap, distToOrderMap];
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
          var distToOrderMap = snapshot.data[1];
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: distToOrderMap.length,
              itemBuilder: (ctx, i) => OrderItem(
                  distributorMapItem: distributorMap,
                  orderList: distToOrderMap[distToOrderMap.keys.toList()[i]],
                  distributorID: distToOrderMap.keys.toList()[i]),
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
  final List orderList;
  final String distributorID;

  const OrderItem({
    Key? key,
    required this.distributorMapItem,
    required this.orderList,
    required this.distributorID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(.runtimeType);
    return Container(
        margin: const EdgeInsets.all(10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  distributorMapItem[distributorID]["Name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(distributorMapItem[distributorID]["Address"]),
              ],
            ),
            Row(
              children: [
                Text(orderList[0]["Status"]),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20.0,
                  textDirection: TextDirection.ltr,
                  semanticLabel: 'Icon',
                ),
              ],
            ),
          ],
        ));
  }
}
