import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mainScreens/bookdetails.dart';
import 'edit_item.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class fetchBooks extends StatefulWidget {

  fetchBooks({super.key, });

  @override
  State<fetchBooks> createState() => _fetchBooksState();
}

class _fetchBooksState extends State<fetchBooks> {
  String category = "";

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> _itemsFuture =
        FirebaseFirestore.instance.collection('books').get();
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
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      item['photo'].toString(),
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ),
                                    SizedBox(
                                      height: 8,
                                      width: 15,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 8,
                                          width: 10,
                                        ),
                                        Text(
                                          item['bookname'].toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20, width: 10),
                                        Text(
                                          item['price'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        SizedBox(height: 20, width: 10),
                                        Text(
                                          item['bookwriter'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20, width: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        editItem(
                                                            itemId: itemId),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                delete(itemId);
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
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

  delete(String itemId) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference documentRef =
        firestore.collection('books').doc(itemId);

    documentRef.delete().then((_) {
      Fluttertoast.showToast(msg: "done");
    }).catchError((error) {
      print('Error deleting document: $error');
    });
  }
}
