// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driversapp/screens/app/summary_page.dart';
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user_stored.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
// import 'package:driversapp/static_assets/appbar_wave.dart';
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
      final user_box = await Hive.openBox<UserStore>('user');
      final driver_route = user_box.getAt(0)?.route;
      var distributorSet = <dynamic>[];
      Map<String, dynamic> map = {};
      await FirebaseFirestore.instance
          .collection("Distributors")
          .get()
          .then((QuerySnapshot querySnaphot) {
        querySnaphot.docs.forEach((doc) {
          if (doc["Route"] == driver_route) {
            var name = doc["Name"];
            var Map = doc["Map"];
            distributorSet.add(doc["Name"]);
            map.addEntries([MapEntry(name, Map)]);
          }
        });
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
          print(snapshot.data);
          return Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width, // Full Width of Screen
              height: 500.0,
              child: ListView.builder(
                  itemCount: finalList.length,
                  itemBuilder: (BuildContext, int index) {
                    const SizedBox(height: 10.0);

                    return Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(finalList[index]),
                          trailing: Icon(
                            Icons.location_on_outlined,
                            color: Colors.lightBlue,
                          ),
                          onTap: () {
                            print(index);
                            List values = finalMap.values.toList();
                            var MapCord = values[index];
                            var Lot = double.parse(MapCord.split(",")[0]);
                            var Lat = double.parse(MapCord.split(",")[1]);
                            openMap(Lot, Lat);
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
  String googleMapUrl =
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
  if (await canLaunch(googleMapUrl)) {
    await launch(googleMapUrl);
  } else {
    throw 'couldnt laod the url';
  }
}
