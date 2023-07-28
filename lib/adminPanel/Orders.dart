import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("orders"),
      ),
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'new order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'under proccess',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'delivered',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'all order',
          ),
        ],
      ),
    );
  }
}


Widget _buildScreen(int index) {
  switch (index) {
    case 0:
      return newOrder();
    case 1:
      return SearchScreen();
    case 2:
      return SettingsScreen();
    case 3:
       return all_order();
    default:
      return newOrder();
  }
}
class newOrder extends StatelessWidget {
  const newOrder({super.key});

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> _itemsFuture =
    FirebaseFirestore.instance.collection('orders').get();

    return Container(
        child: ListView(
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
                      if (item['status'] == "طلب جديد") {
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
        ));
  }
}

class SearchScreen extends StatelessWidget {
  Future<QuerySnapshot> _itemsFuture =
      FirebaseFirestore.instance.collection('orders').get();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
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
                  if (item['status'] == "تحت التجهيز") {
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
    ));
  }
}

class SettingsScreen extends StatelessWidget {
  Future<QuerySnapshot> _itemsFuture =
      FirebaseFirestore.instance.collection('orders').get();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
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
                    if (item['status'] == "تم توصيل الطلب") {
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

class all_order extends StatelessWidget {
  Future<QuerySnapshot> _itemsFuture =
      FirebaseFirestore.instance.collection('orders').get();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Add your favorite button action here
                                        },
                                        icon:
                                            const Icon(Icons.add_shopping_cart),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          // Add your favorite button action here
                                        },
                                        icon: const Icon(Icons.favorite_border),
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
    ));
  }
}
