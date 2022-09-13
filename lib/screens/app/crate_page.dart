import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/user_stored.dart';

class Cratepage extends StatefulWidget {
  const Cratepage({Key? key}) : super(key: key);

  @override
  State<Cratepage> createState() => _CratepageState();
}

class _CratepageState extends State<Cratepage> {
  @override
  Widget build(BuildContext context) {
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
        const CratePagebody(),
      ])),
    );
  }
}

class CratePagebody extends StatefulWidget {
  const CratePagebody({Key? key}) : super(key: key);

  @override
  State<CratePagebody> createState() => _CratePagebodyState();
}

class _CratePagebodyState extends State<CratePagebody> {
  late String _numofcrates;
  late String _currDist;
  late String _value = "";
  @override
  void initState() {
    super.initState();
    _numofcrates = "";
    _currDist = "";
    _value = "";
  }

  @override
  Widget build(BuildContext context) {
    Future getCrate() async {
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
            var crates = doc["Crates"];
            distributorSet.add(doc["Name"]);
            map.addEntries([MapEntry(name, crates)]);
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
          List<String> finalList = [];
          Map<String, dynamic> finalMap = snapshot.data.cast<String, dynamic>();
          List<String> crates = [];

          finalMap.forEach((key, value) {
            finalList.add(key);
          });
          finalMap.forEach((key, value) {
            crates.add(value);
          });

          _numofcrates = crates[0];

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
                    const Text(
                      "Distributors Name",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    DropdownSearch<String>(
                      items: finalList,
                      validator: (String? item) {
                        if (item == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String? data) {
                        {
                          var crateRem = finalMap['$data'];
                          _currDist = data!;
                          _numofcrates = crateRem;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Crates Value",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Returned Number of Crates are',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        _value = value;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    MaterialButton(
                        color: Colors.lightBlueAccent,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          var finalCrate =
                              int.parse(_value) - int.parse(_numofcrates);

                          FirebaseFirestore.instance
                              .collection("Distributors")
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            for (var doc in querySnapshot.docs) {
                              if (doc["Name"] == _currDist) {
                                doc.reference.update({'Crates': '$finalCrate'});
                              }
                            }
                          });
                        })
                  ]));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
