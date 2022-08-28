
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
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
            CratePagebody(),
          ])),
    );
  }
}


class CratePagebody extends StatefulWidget {
  @override
  State<CratePagebody> createState() => _CratePagebodyState();
}

class _CratePagebodyState extends State<CratePagebody> {
  @override
  Widget build(BuildContext context) {
    Future getCrate() async {

      final user_box = await Hive.openBox<UserStore>('user');
      final driver_route = user_box
          .getAt(0)
          ?.route;

      var distributorSet = <dynamic>[];
      await FirebaseFirestore.instance
          .collection("Distributors").get().
      then((QuerySnapshot querySnaphot) {
        querySnaphot.docs.forEach((doc) {
          if (doc["Route"] == driver_route) {
            distributorSet.add(doc["Name"]);

          }
        });
      });
      print(distributorSet);
      return distributorSet;
    }
    return FutureBuilder<dynamic>(
      future: getCrate(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        // if (snapshot.hasData) {
        //   return const Text("Document does not exist");
        // }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {

          List<String> finalList = snapshot.data.cast<String>();
          String dropdownValue = finalList[0];

          String CrateRem = "23";
          return Container(


            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width, // Full Width of Screen
            height: 500.0, // Desired Height
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              const Text('Distributor', style: TextStyle(fontSize: 18.5)),
              DropdownButton(
                isExpanded: true,
                value: dropdownValue,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
                items: finalList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Crates Received', style: TextStyle(fontSize: 18.5)),
              const SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'The remaining crates left are $CrateRem',
                    border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {
                  //Do something with this value
                },
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                  color: Colors.lightBlueAccent,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {})
            ]),
          );



        }
        return const CircularProgressIndicator();
      },
    );
  }
}


