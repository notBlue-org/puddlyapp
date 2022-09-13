import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
import 'package:driversapp/utils/login.dart';
import 'package:driversapp/widget/cust_appbar.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: custAppBar("Home"),
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          child: WaveSvg(),
        ),
        Positioned(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: <Widget>[
                _getButton(context, Icons.directions_car, "Store Locator",
                    "/store_page"),
                _getButton(
                    context, Icons.shopping_cart, "My Orders", "/order_page"),
                _getButton(context, Icons.all_inbox_sharp, "Crate Management",
                    "/crate_page"),
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
              backgroundColor: Colors.transparent,
              // elevation: 0,
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () async {
              FireAuth.signOut(context);
            },
          ),
        ),
        // TODO: Get smaller bottom bar svg from anji
        // Positioned(
        //   bottom: -320,
        //   child: BottomWave(),
        // )
      ]),
    );
  }
}

Column _getButton(
    BuildContext context, IconData givenIcon, String label, String navPage) {
  return Column(children: [
    Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SizedBox(
        height: 150,
        width: 150,
        child: TextButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
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
            Navigator.of(context).pushNamed(
              navPage,
            );
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
