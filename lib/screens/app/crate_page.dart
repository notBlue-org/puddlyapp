import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';

class CratePage extends StatefulWidget {
  const CratePage({Key? key}) : super(key: key);

  @override
  _CratePageState createState() => _CratePageState();
}

class _CratePageState extends State<CratePage> {
  String dropdownValue = 'Safe Productions';

  String CrateRem = "23";
  var items = [
    'Safe Productions',
    'Temp Productions',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Crate Management"),
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          child: WaveSvg(),
        ),
        Container(
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
            items: items.map((String items) {
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
          const Text('Crates Recived', style: TextStyle(fontSize: 18.5)),
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
      ),
      ]),
    );
  }
}
