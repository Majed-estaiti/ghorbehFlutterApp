import 'package:Ghorbeh/adminPanel/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ghorbeh/adminPanel/sendOrder.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
import '../mainScreens/bookdetails.dart';
class addNewOrder extends StatefulWidget {
  @override
  _addNewOrderState createState() => _addNewOrderState();
}

class _addNewOrderState extends State<addNewOrder> {
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

      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey[900],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => sendOrder()));
            },
            child: Text("go send order"),
          ),
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

                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: (

                                              ) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => editItem(itemId: itemID),
                                              ),
                                            );                                          },
                                          icon: const Icon(
                                              Icons.edit),
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
