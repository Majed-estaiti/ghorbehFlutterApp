import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String itemId = "";
  late BannerAd bannerAd;
  bool isloaded = false;

  BannerAdreq() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5673812127688406/6036749836",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isloaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: AdRequest());
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    itemId = widget.itemId;
    BannerAdreq();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('Book Details'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('books').doc(itemId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Item not found'));
          }

          var itemData = snapshot.data!.data() as Map;
          var title = itemData!["bookname"];
          double price = itemData['price'];
          var imageUrl = itemData['photo'];
          var desc = itemData["desc"];

          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.network(
                      imageUrl,
                      width: 200,
                      height: 250,
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          "Book Name : " + title,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Price : $price",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                addToCart(itemId, title, imageUrl, price);
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                addTofav(
                                    itemId,
                                    itemData['bookname'],
                                    itemData['photo'],
                                    itemData['bookwriter'],
                                    itemData['price']);
                              },
                              icon: const Icon(Icons.favorite_border),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "about",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          desc,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                Column(
                  children: [
                    isloaded
                        ? SizedBox(
                            height: bannerAd.size.height.toDouble(),
                            width: bannerAd.size.width.toDouble(),
                            child: AdWidget(
                              ad: bannerAd,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void addToCart(String itemId, String title, String photo, double price) async {
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

    Fluttertoast.showToast(msg: "Item added to cart");

    // Show a success message or perform any other actions after adding to the cart
  } catch (e) {
    Fluttertoast.showToast(msg: "Failed to add item to cart");
  }
}
