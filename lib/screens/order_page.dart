import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/screens/summary_page.dart';
import 'package:driversapp/widget/nav_bar.dart';



import 'package:flutter/material.dart';
class OrderPage extends StatefulWidget {
  const OrderPage({ Key? key }) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  get queryString => "Distributor";
  get queryString1 => "0";
  get brand=>"";
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Distributors").where("Type",isEqualTo:queryString).snapshots(),
        builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView (
              children: snapshot.data?.docs.
              where((QueryDocumentSnapshot<Object?> element) =>
                  element["Route"].contains(queryString1)
              ).
              map(
                    (doc) =>
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: GestureDetector(
                        child: const Icon(Icons.shopping_bag),

                      ),
                      title: Text(doc["Name"]),
                      subtitle:Text(doc["Brand"]),

                      trailing:  IconButton(
                        icon:const Icon(Icons.arrow_forward_ios),
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>summaryPage(docId:doc.id,brand:doc["Brand"])));
                        },
                      ),
                    ),
              ).toList() as List<Widget>
          );
        },
      ),
    );
  }
}