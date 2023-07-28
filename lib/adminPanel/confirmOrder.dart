import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Ghorbeh/adminPanel/adminDashbpord.dart';
import 'package:Ghorbeh/mainScreens/home_Screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class confirmOrder extends StatefulWidget {
  final double totprice;

  const confirmOrder({required this.totprice});

  @override
  State<confirmOrder> createState() => _confirmOrderState();
}

class _confirmOrderState extends State<confirmOrder> {
  late double storedValue;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController voucher = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<dynamic> itemList = [];

  Future<void> getItemListFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("booksInCart")
          .get();

      setState(() {
        itemList = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error getting item list from Firebase Firestore: $e');
    }
  }

  Future<void> deleteCollection() async {
    final collectionRef = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("booksInCart");

    final QuerySnapshot snapshot = await collectionRef.get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (var document in documents) {
      await document.reference.delete();
    }
  }


  void sendOrderToFirebase() async {
    if (phone.text.isNotEmpty &&
        address.text.isNotEmpty &&
        name.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return loaedingProg(
              message: "sending your order",
            );
          });

      try {
        // Create a new document reference in the "orders" collection
        final docRef = FirebaseFirestore.instance.collection('orders').doc();

        // Set the item list and shipping details as fields in the document
        final orderData = {
          'items': itemList,
          'name': name.text.trim(),
          'address': address.text.trim(),
          'phone': phone.text.trim(),
          'userid': FirebaseAuth.instance.currentUser?.uid,
          'status': "طلب جديد",
        };
        await docRef.set(orderData);
        deleteCollection();
        Fluttertoast.showToast(msg: "order sent successfully");
        Navigator.push(context, MaterialPageRoute(builder: (c) => adminDash()));
      } catch (e) {
        print('please try again');
      }
    }else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "please complete the form");
    }
  }

  @override
  void initState() {
    super.initState();
    storedValue = widget.totprice;
    getItemListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipping details"),
        backgroundColor: Colors.blueGrey[300],

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Text("Customer information",  style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 12,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      customTextField(
                        textEditingController: name,
                        iconData: Icons.person,
                        hintText: "Name",
                        isObsec: false,
                        enabled: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        textEditingController: address,
                        iconData: Icons.location_on_outlined,
                        hintText: "address",
                        isObsec: false,
                        enabled: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        textEditingController: phone,
                        iconData: Icons.phone,
                        hintText: "phone",
                        isObsec: false,
                        enabled: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 12,
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              const SizedBox(
                height: 12,
              ),
              Text("payment summary ",  style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 12,
              ),
              Container(padding: const EdgeInsets.all(15),child:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Books price : $storedValue ",  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("delivery : 1.0 JD",  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("Taxes : 0.0",  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("Total amount : ${storedValue + 1}",  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),),

                ],),),



              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                  onPressed: () {
                    sendOrderToFirebase();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
