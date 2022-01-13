import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/utils/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body: Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,

            children: <Widget>[

              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:SizedBox(
                  height: 150,
                  width: 150,
                child:
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    side: BorderSide(width: 2,color: kBackground),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(30)
                    )
                  ),
                  onPressed: (){},
                  icon: Icon(Icons.directions_car,
                  size: 50),
                  label: Text('LOAD'),
                ),
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:SizedBox(
                  height: 150,
                  width: 150,
                  child:
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        side: BorderSide(width: 2,color: kBackground),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30)
                        )
                    ),
                    onPressed: (){},
                    icon: Icon(Icons.shopping_cart_rounded,
                        size: 50),
                    label: Text('ORDERS'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:SizedBox(
                  height: 150,
                  width: 150,
                  child:
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        side: BorderSide(width: 2,color: kBackground),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30)
                        )
                    ),
                    onPressed: (){},
                    icon: Icon(Icons.all_inbox_sharp,
                        size: 50),
                    label: Text('CRATES'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:SizedBox(
                  height: 150,
                  width: 150,
                  child:
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        side: BorderSide(width: 2,color: kBackground),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30)
                        )
                    ),
                    onPressed: ()async{
                      FireAuth.signOut(context);
                    },
                    icon: Icon(Icons.logout,
                        size: 50),
                    label: Text('LOGOUT'),
                  ),
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}
