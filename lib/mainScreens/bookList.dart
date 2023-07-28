import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bookdetails.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class bookList extends StatefulWidget {
  final String cat;

  bookList({super.key, required this.cat});

  @override
  State<bookList> createState() => _bookListState();
}

class _bookListState extends State<bookList> {
  String category = "";

  @override
  void initState() {
    super.initState();
    category = widget.cat;
  }



  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> _itemsFuture =
    FirebaseFirestore.instance.collection('books').where("category",isEqualTo: category).get();
    return Scaffold(
        appBar: AppBar(
          title: const Text("List"),
          backgroundColor: Colors.blueGrey[300],
        ),
        body: Container(
          color: Colors.blueGrey[50],
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<QuerySnapshot>(
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
                          color: Colors.blueGrey[50],
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 300),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      item['photo'],
                                      fit: BoxFit.cover,
                                      height: 170,
                                      width: 120,
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                        const SizedBox(
                                            height: 10, width: 10),
                                       /* Text(
                                          item['bookwriter'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),

                                        */
                                        const SizedBox(
                                            height: 10, width: 10),
                                        Text(
                                          item['price'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        const SizedBox(
                                            height: 20, width: 10),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                addToCart(
                                                    itemId,
                                                    item['bookname'],
                                                    item['photo'],
                                                    item['price']);
                                              },
                                              icon: const Icon(
                                                  Icons.add_shopping_cart),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {
                                                addTofav(
                                                    itemId,
                                                    item['bookname'],
                                                    item['photo'],
                                                    item['bookwriter'],
                                                    item['price']);
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
              return const Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  LinearProgressIndicator()
                ],
              );
            },
          ),
        ));
  }

  void addToCart(
      String itemId, String title, String photo, double price) async {
    try {
      // Get a reference to the cart collection
      CollectionReference cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("booksInCart");
      await cartCollection.doc(itemId).set({
        'itemId': itemId,
        'bookname': title,
        'price': price,
        'photo': photo,
        // Add any other relevant fields of the item to the cart
        // For example: 'title', 'description', 'imageUrl', etc.
      });

      Fluttertoast.showToast(msg: "Item added to cart");

      // Show a success message or perform any other actions after adding to the cart
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to add item to cart");
    }
  }

  void addTofav(String itemId, String title, String photo, String bookwriter,
      double price) async {
    try {
      // Get a reference to the cart collection
      CollectionReference cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("fav");
      await cartCollection.doc(itemId).set({
        'itemId': itemId,
        'bookname': title,
        'bookwriter': bookwriter,
        'price': price,
        'photo': photo,
        // Add any other relevant fields of the item to the cart
        // For example: 'title', 'description', 'imageUrl', etc.
      });

      Fluttertoast.showToast(msg: "book added to favorites list");

      // Show a success message or perform any other actions after adding to the cart
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to add book to favorites list");
    }
  }
}
