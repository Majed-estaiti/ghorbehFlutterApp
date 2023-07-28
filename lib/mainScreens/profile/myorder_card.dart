import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class myOrder_card extends StatefulWidget {
  const myOrder_card({super.key});

  @override
  State<myOrder_card> createState() => _myOrder_cardState();
}

class _myOrder_cardState extends State<myOrder_card> {
  Future<QuerySnapshot> _itemsFuture =
      FirebaseFirestore.instance.collection('orders').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Last order"),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final documents = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final item = documents[index];
                    final list = item['items'] as List<dynamic>;

                    if (item['userid'] ==
                        FirebaseAuth.instance.currentUser?.uid) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 7,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10, width: 10),
                                      Text(
                                        item['phone'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10, width: 10),
                                      Text(
                                        item['status'].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      const SizedBox(height: 20, width: 10),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 8,
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final item = list[index]["bookname"];

                                  return ListTile(
                                    title: Text(item),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return const Text('Error fetching data');
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
