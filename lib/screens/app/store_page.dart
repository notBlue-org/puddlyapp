// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driversapp/screens/app/summary_page.dart';
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user_stored.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widget/cust_appbar.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Store Locator"),
      body: Center(
          child: Column(children: [
        SizedBox(
            height: 150,
            child: Stack(children: [Positioned(top: 0, child: WaveSvg())])),
        const StorePageBody(),
      ])),
    );
  }
}

class StorePageBody extends StatelessWidget {
  const StorePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future getMap() async {
      final userBox = await Hive.openBox<UserStore>('user');
      final driverRoute = userBox.getAt(0)?.route;
      var distributorSet = <dynamic>[];
      Map<String, dynamic> map = {};
      await FirebaseFirestore.instance
          .collection("Distributors")
          .get()
          .then((QuerySnapshot querySnaphot) {
        for (var doc in querySnaphot.docs) {
          if (doc["Route"] == driverRoute) {
            var name = doc["Name"];
            var mapEntry = doc["Map"];
            distributorSet.add(doc["Name"]);
            map.addEntries([MapEntry(name, mapEntry)]);
          }
        }
      });

      return map;
    }

    return FutureBuilder<dynamic>(
      future: getMap(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          List<String> finalList = [];
          Map<String, dynamic> finalMap = snapshot.data.cast<String, dynamic>();
          finalMap.forEach((key, value) {
            finalList.add(key);
          });
          return Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width, // Full Width of Screen
              height: 500.0,
              child: ListView.builder(
                  itemCount: finalList.length,
                  itemBuilder: (context, int index) {
                    const SizedBox(height: 10.0);

                    return Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(finalList[index]),
                          trailing: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.lightBlue,
                          ),
                          onTap: () {
                            List values = finalMap.values.toList();
                            var mapCord = values[index];
                            var lot = double.parse(mapCord.split(",")[0]);
                            var lat = double.parse(mapCord.split(",")[1]);
                            openMap(lot, lat);
                          },
                        ));
                  }));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

Future<void> openMap(latitude, longitude) async {
  print(latitude);
  String googleMapUrl =
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
  if (await canLaunch(googleMapUrl)) {
    await launch(googleMapUrl);
  } else {
    throw 'couldnt load the url';
  }
}
