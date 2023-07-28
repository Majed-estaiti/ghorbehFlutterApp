import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

double calculateTotalPrice(QuerySnapshot<Map<String, dynamic>> snapshot) {
  double totalPrice = 0.0;
  snapshot.docs.forEach((doc) {
    totalPrice += doc['price'] ?? 0.0; // Assuming the price field is stored as a double
  });
  return totalPrice;
}

Future<double> calculateprice() async {
  // Assuming you have already set up Firebase and initialized it in your app

  CollectionReference<Map<String, dynamic>> itemsCollection =
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("booksInCart");

  QuerySnapshot<Map<String, dynamic>> snapshot = await itemsCollection.get();

  List<Item> items = snapshot.docs.map((doc) {
    return Item(name: doc['bookname'], price: doc['price']);
  }).toList();

  double totalPrice = calculateTotalPrice(snapshot);
  return totalPrice;
}
