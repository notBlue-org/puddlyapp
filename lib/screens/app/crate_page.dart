import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:driversapp/screens/app/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  late String crateRem;
  late String _currDist;
  late String _value = "";
  @override
  void initState() {
    super.initState();
    crateRem = "";
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
                      onChanged: (String? data) async {
                        {
                          print(data);
                          crateRem = finalMap['$data'];
                          print(crateRem);
                          _currDist = data!;
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
                          hintText: 'Returned Number of Crates are $crateRem',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 192, 103, 103),
                                  width: 1.0),
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
                          style:
                              TextStyle(color: Color.fromARGB(255, 17, 12, 12)),
                        ),
                        onPressed: () {
                          if (_value == "") {
                            Misc.createSnackbar(context,
                                "Please enter the number of crates recieved");
                            return;
                          }
                          print(crateRem);
                          print(_value);

                          int finalCrate =
                              int.parse(crateRem) - int.parse(_value);
                          print(finalCrate);
                          FirebaseFirestore.instance
                              .collection("Distributors")
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            for (var doc in querySnapshot.docs) {
                              if (doc["Name"] == _currDist) {
                                doc.reference.update({'Crates': '$finalCrate'});
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
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
