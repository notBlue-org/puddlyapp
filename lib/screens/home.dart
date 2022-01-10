import 'package:driverapp/widgets/boxwid.dart';
import 'package:flutter/material.dart';
import '../../static_assets/wave_svg.dart';
import '../../static_assets/bottom_wave.dart';

class Extra extends StatelessWidget {
  const Extra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Driver',
      home: BoxWid(),
    );
  }
}
