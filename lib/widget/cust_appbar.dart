import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

custAppBar(String title) {
  return AppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    titleSpacing: 0,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0.0,
    title: Text(title),
  );
}