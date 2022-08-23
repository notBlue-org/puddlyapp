// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driversapp/screens/app/summary_page.dart';
import 'package:driversapp/static_assets/wave_svg.dart';
// import 'package:driversapp/static_assets/appbar_wave.dart';
import 'package:driversapp/widget/nav_bar.dart';
import 'package:flutter/material.dart';
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
            child:
                Stack(children: [Positioned(top: 0, child: WaveSvg())])),
        const StorePageBody(),
      ])),
    );
  }
}

class StorePageBody extends StatelessWidget {
  const StorePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Center(child: Text("Store Locater page"))],
    );
  }
}
