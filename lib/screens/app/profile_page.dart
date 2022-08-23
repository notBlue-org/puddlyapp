// import 'package:driversapp/constants/colors.dart';
// import 'package:driversapp/models/user_stored.dart';
// import 'package:driversapp/models/boxes.dart';
// import 'package:driversapp/static_assets/appbar_wave.dart';
// import 'package:driversapp/utils/login.dart';
// import 'package:driversapp/widget/cust_appbar.dart';
// import 'package:driversapp/widget/nav_bar.dart';
// // import 'package:driversapp/widgets/cust_appbar.dart';
// // import 'package:driversapp/widgets/nav_drawer.dart';
// import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         extendBodyBehindAppBar: true,
//         drawer: const NavDrawer(),
//         appBar: custAppBar("Profile Page"),
//         body: Column(children: [
//           SizedBox(
//               height: 150,
//               child: Stack(
//                   children: [Positioned(top: 0, child: CustomWaveSvg())])),
//           const ProfileBody()
//         ]));
//   }
// }

// class ProfileBody extends StatelessWidget {
//   const ProfileBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Box<UserStore>>(
//       valueListenable: Boxes.getUserStore().listenable(),
//       builder: (context, box, _) {
//         final userDetails = box.values.toList().cast<UserStore>();
//         double width = MediaQuery.of(context).size.width;

//         return Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ..._getField(width, "Distributor Name",
//                     userDetails.elementAt(0).username),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // ..._getField(
//                 //     width, "User Class", userDetails.elementAt(0).type),
//                 // const SizedBox(
//                 //   height: 10,
//                 // ),
//                 ..._getField(width, "Email", userDetails.elementAt(0).email),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(primary: kButtonColor),
//                     onPressed: () async {
//                       FireAuth.signOut(context);
//                     },
//                     child: const Text('Sign out'))
//               ]),
//         );
//       },
//     );
//   }
// }

// _getField(width, label, value) {
//   return [
//     Container(
//       padding: EdgeInsets.fromLTRB(0.1 * width, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         label,
//         textAlign: TextAlign.left,
//         style:
//             const TextStyle(color: kButtonColor, fontWeight: FontWeight.bold),
//       ),
//     ),
//     const SizedBox(
//       height: 5,
//     ),
//     Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0),
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: Color.fromRGBO(13, 21, 129, 0.03),
//                 blurRadius: 100.0,
//                 offset: Offset(0, 10.0),
//                 spreadRadius: 2,
//               ),
//             ]),
//         height: 50,
//         width: 0.8 * width,
//         padding: const EdgeInsets.all(15),
//         child: Text(
//           value,
//           style: const TextStyle(color: kButtonColor),
//         ))
//   ];
// }
