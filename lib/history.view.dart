import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('history'),
        backgroundColor: Colors.green[700],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("locations").snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
                children: snapshot.data!.docs.map(
              (DocumentSnapshot e) {
                Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 5,
                            offset: Offset(0, 2),
                            color: Colors.black38)
                      ]),
                  child: Column(
                    children: [
                      Text("lat : ${data["Lat"]}"),
                      Text("long : ${data["Long"]}"),
                      Text("address : ${data["address"]}"),
                      Text("date : ${data["date"]}")
                    ],
                  ),
                );
              },
            ).toList());
          }
        }),
      ),
    );
  }
}
