import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_stored.dart';
import '../../widget/nav_bar.dart';

class payment extends StatefulWidget {
  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  @override
  Widget build(BuildContext context) {
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
        paymentBody(),
      ])),
    );
  }
}

class paymentBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future getQR() async {
      final user_box = await Hive.openBox<UserStore>('user');
      final driver_route = user_box.getAt(0)?.route;
      final driver_name = user_box.getAt(0)?.username;
      List<String> map = [];
      await FirebaseFirestore.instance
          .collection("Drivers")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc["Name"] == driver_name && doc["Route"] == driver_route) {
            var name = doc["Name"];
            var QR = doc["QR"];
            map.add(name);
            map.add(QR);
            print(map);
          }
        });
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
            String name = finalMap[0];
            return Container(
                child: Row(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      height: 250,
                      width: 250,
                    ))
              ],
            ));
          }
          return const CircularProgressIndicator();
        });
  }
}
