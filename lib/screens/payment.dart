import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class payment extends StatefulWidget {


  @override

  _paymentState createState() => _paymentState();
}



class _paymentState extends State<payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Drivers").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Loading..."),
                    SizedBox(
                      height: 50.0,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          snapshot.data?.docs[index]["Name"]),        // getting the data from firestore
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
