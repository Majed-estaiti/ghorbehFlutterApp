import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bookdetails.dart';

class myFav_card extends StatefulWidget {
  const myFav_card({super.key});

  @override
  State<myFav_card> createState() => _myFav_cardState();
}

class _myFav_cardState extends State<myFav_card> {
  final Future<QuerySnapshot> _itemsFuture = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("fav")
      .get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("favorites"),
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
                    final itemId = item.id;
                    return GestureDetector(
                        onTap: () {
                          DocumentSnapshot documentSnapshot;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemDetailsScreen(itemId: itemId),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey[900],
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .collection("fav")
                                          .doc(itemId)
                                          .delete()
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "book deleted from list"));
                                    },
                                    child: Text("Delete")),
                                Row(
                                  children: [
                                    Image.network(
                                      item['photo'],
                                      fit: BoxFit.cover,
                                      height: 170,
                                    ),
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
                                          item['bookname'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10, width: 10),
                                        Text(
                                          item['bookwriter'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10, width: 10),
                                        Text(
                                          item['price'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        const SizedBox(height: 20, width: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // Add your favorite button action here
                                              },
                                              icon: const Icon(
                                                  Icons.add_shopping_cart),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {
                                                // Add your favorite button action here
                                              },
                                              icon: const Icon(
                                                  Icons.favorite_border),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ));
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
