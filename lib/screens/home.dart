import 'package:flutter/material.dart';
import '../../static_assets/wave_svg.dart';
import '../../static_assets/bottom_wave.dart';

class Extra extends StatelessWidget {
  const Extra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: -10,
          child: WaveSvg(),
        ),
        // waveBar(),
        Positioned(
          bottom: -310,
          child: BottomWave(),
        )
      ]),
    );
  }
}
