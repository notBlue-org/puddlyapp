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
      appBar: AppBar(title:Text("Payment QR")),
      body: Container(
          alignment: Alignment.center,
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
                  children: const <Widget>[
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
                  return Container(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                          snapshot.data?.docs[index]["Name"]),
                      leading: Image.network(snapshot.data?.docs[index]["DriverQR"]),

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
