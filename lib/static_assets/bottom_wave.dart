// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomWave extends StatelessWidget {
  static String assetName = 'assets/images/bottom_wave.svg';
  Widget svg = SvgPicture.asset(
    assetName,
  );

  @override
  Widget build(BuildContext context) {
    return svg;
  }
}
