import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class summaryPage extends StatefulWidget {
  String docId;
  String brand;
  summaryPage({Key? key,required this.docId, required this.brand}) : super(key: key);

  @override
  State<summaryPage> createState() => _summaryPageState();
}

class _summaryPageState extends State<summaryPage> {

  get queryString => "Ordered";
  dynamic data;
  CollectionReference dist=FirebaseFirestore.instance.collection("Orders");

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Center(child:StreamBuilder(
          stream: dist.where("DistributorID",isEqualTo: widget.docId).snapshots(),
          builder:(BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
                children: snapshot.data?.docs.
                where((QueryDocumentSnapshot<Object?> element) =>
                    element["Status"].contains(queryString)
                ).
                map(
                      (doc) =>
                      ListTile(
                        contentPadding: EdgeInsets.zero,

                        leading: GestureDetector(
                          child: const Icon(Icons.shopping_bag),

                        ),
                        title: Text(doc["DistributorID"]),

                      ),
                ).toList() as List<Widget>,

            );},
        ),)
    );
  }
}



