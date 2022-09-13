import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomWave extends StatelessWidget {
  static String assetName = 'assets/images/bottom_wave.svg';
  final Widget svg = SvgPicture.asset(
    assetName,
  );

  BottomWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return svg;
  }
}
