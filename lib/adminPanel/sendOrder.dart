
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Ghorbeh/adminPanel/confirmOrder.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class CartItem {
  final String name;
  final double price;
  final String photo;
  final String id;

  CartItem(
      {required this.name,
        required this.price,
        required this.photo,
        required this.id});
}

class sendOrder extends StatelessWidget {
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("booksInCart")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CartItem> cartItems = snapshot.data!.docs.map((doc) {
              return CartItem(
                  name: doc['bookname'],
                  photo: doc['photo'],
                  price: doc['price'],
                  id: doc.id);
            }).toList();

            double totalPrice = calculateTotalPrice(cartItems);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 7,
                        child: Container(
                          color: Colors.blueGrey[50],
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
                                        .collection("booksInCart")
                                        .doc(cartItems[index].id)
                                        .delete()
                                        .then((value) => Fluttertoast.showToast(
                                        msg: "book deleted from list"));
                                  },
                                  child: Text("Delete")),
                              Row(
                                children: [
                                  Image.network(
                                    cartItems[index].photo,
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
                                        " ${cartItems[index].name}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10, width: 10),
                                      Text(
                                        " ${cartItems[index].price}",
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                      ),
                      onPressed: () {
                        if (cartItems.length <= 0) {
                          Fluttertoast.showToast(
                              msg: "you must add  at least one book to cart");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => confirmOrder(
                                  totprice: totalPrice,
                                ),
                              ));
                        }
                      },
                      child: Text("Confirm order"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Total Price: $totalPrice',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item.price;
    }
    this.totalPrice = totalPrice;
    return totalPrice;
  }
}
