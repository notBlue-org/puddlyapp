import 'package:driversapp/utils/login.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Drawer(
        child: Material(
          color: Colors.lightBlueAccent,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // CustomInvertWaveSvg(),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),
              ),
              _getListTile(context, Icons.home, 'Home', '/home_page'),
              const Divider(
                color: Colors.white,
                indent: 10.0,
                endIndent: 30.0,
              ),
              _getListTile(context, Icons.directions_car, 'Store Locator',
                  '/store_page'),
              const Divider(
                color: Colors.white,
                indent: 10.0,
                endIndent: 30.0,
              ),
              _getListTile(
                  context, Icons.shopping_bag, 'Delivery List', '/order_page'),
              const Divider(
                color: Colors.white,
                indent: 10.0,
                endIndent: 30.0,
              ),

              const Divider(
                color: Colors.white,
                indent: 10.0,
                endIndent: 30.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () async => {
                  FireAuth.signOut(context),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_getListTile(
    BuildContext context, IconData givenIcon, String label, String navPage) {
  return ListTile(
    leading: Icon(
      givenIcon,
      color: Colors.white,
    ),
    title: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    onTap: () => {
      Navigator.of(context).pushReplacementNamed(
        navPage,
      )
    },
  );
}
