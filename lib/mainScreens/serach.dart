import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
import '../widgets/drawer.dart';
import 'bookdetails.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<DocumentSnapshot> searchResults = [];

  Future<void> searchDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('bookname', isGreaterThanOrEqualTo: searchQuery)
        .where('bookname', isLessThan: searchQuery + 'z')
        .get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],

      drawer: drawer(),
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
              searchDocuments();
            },
            decoration: InputDecoration(
              hintText: 'Enter your search query',
              border: OutlineInputBorder(),
              // Sets a border around the TextField
              filled: true,
              // Fills the TextField background with a color
              fillColor:
                  Colors.white70, // Sets the background color of the TextField
            ),
          ),
          searchResults.isNotEmpty && searchQuery.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = searchResults[index];
                      final itemID=document.id;
                      return GestureDetector(
                          onTap: () {
                            DocumentSnapshot documentSnapshot;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsScreen(
                                    itemId: itemID),
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
                                        document['photo'].toString(),
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 150,
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
                                            document['bookname'].toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20, width: 10),
                                          Text(
                                            document['price'].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          SizedBox(height: 20, width: 10),
                                          Text(
                                            document['bookwriter'].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20, width: 10),
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 300,
                    ),
                    Text('No documents found'),
                  ],
                ),
        ],
      ),
    );
  }
}
