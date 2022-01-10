// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaveSvg extends StatelessWidget {
  static String assetName = 'assets/images/wave.svg';
  Widget svg = SvgPicture.asset(
    assetName,
  );

  @override
  Widget build(BuildContext context) {
    return svg;
  }
}
