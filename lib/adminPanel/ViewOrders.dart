import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {

  Future<QuerySnapshot> _itemsFuture =
      FirebaseFirestore.instance.collection('orders').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Last order"),
        backgroundColor: Colors.blueGrey[300],
      ),
      body:
      ListView(
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
                    final itemid = item.id;

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          icon:
                                              const Icon(Icons.favorite_border),
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
                            ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(itemid)
                                      .update({'status': 'تحت التجهيز'});
                                },
                                child: Text("Reseved order")),
                            ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(itemid)
                                      .update({'status': 'تم توصيل الطلب'});
                                },
                                child: Text("deleveired order")),
                          ],
                        ),
                      ),
                    );
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
