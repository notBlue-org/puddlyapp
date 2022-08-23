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
      var distributorSet = <dynamic>{};
      await FirebaseFirestore.instance
          .collection(Misc.getCurrentDate())
          .get()
          .then((QuerySnapshot querySnapshot) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
          distributorSet.add(doc["DistributorID"]);
        });
        // print(distributorSet);
      });
      var distributorsOnRoute = <dynamic>{};
      // final user_box = Hive.box('user');
      // final driver_route = user_box.get('route');
      final user_box = await Hive.openBox<UserStore>('user');
      final driver_route = user_box.getAt(0)?.route;

      // print(driver_route);
      // FirebaseFirestore.instance
      //     .collection('Distributors')
      //     .where('Route', isEqualTo: driver_route)
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   querySnapshot.docs.forEach((doc) {
      //     print(doc["Name"]);
      //   });
      // });
      for (var distributor in distributorSet) {
        await FirebaseFirestore.instance
            .collection('Distributors')
            .doc(distributor)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            var distRoute = documentSnapshot.get("Route");
            if (distRoute == driver_route) {
              distributorsOnRoute.add(documentSnapshot.get("DistributorID"));
            }
          }
        });
      }
      return ["a"];
    }

    return FutureBuilder<dynamic>(
      future: getRouteData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        // if (snapshot.hasData) {
        //   return const Text("Document does not exist");
        // }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
          return const Text("Full Name");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
