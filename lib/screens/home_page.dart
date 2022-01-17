import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/static_assets/bottom_wave.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          child: WaveSvg(),
        ),
        Positioned(
            top: 80,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              title: const Text(
                "Home",
                style: TextStyle(
                  color: kButtonColor,
                  fontSize: 30.0,
                ),
              ),
              backgroundColor: Colors.transparent, //No more green
              elevation: 0.0,
            )),
        Positioned(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: <Widget>[
                _getButton(Icons.directions_car, "Store Locator"),
                _getButton(Icons.shopping_cart, "My Orders"),
                _getButton(
                    Icons.checklist_rtl_outlined, "Delivery Confirmation"),
                _getButton(Icons.all_inbox_sharp, "Crate Management"),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 180,
          left: 250,
          child: TextButton.icon(
            icon: const Icon(
              Icons.logout_outlined,
              color: kButtonColor,
            ),
            label: const Text(
              'Log Out',
              style: TextStyle(color: kButtonColor),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              // elevation: 0,
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () async {
              FireAuth.signOut(context);
            },
          ),
        ),
        // TODO: Get smalleer bottom bar svg from anji
        // Positioned(
        //   bottom: -320,
        //   child: BottomWave(),
        // )
      ]),
    );
  }
}

Column _getButton(IconData givenIcon, String label) {
  return Column(children: [
    Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SizedBox(
        height: 150,
        width: 150,
        child: TextButton(
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              // side: const BorderSide(width: 2, color: kBackground),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Icon(
            givenIcon,
            size: 100.0,
            color: kButtonColor,
          ),
          onPressed: () {
            print("hello");
          },
        ),
      ),
    ),
    const SizedBox(height: 10),
    Text(
      label,
      style: const TextStyle(
        color: kButtonColor,
        fontSize: 14.0,
      ),
    ),
    const SizedBox(height: 10),
  ]);
}
