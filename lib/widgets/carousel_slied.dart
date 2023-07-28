import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCarousel extends StatefulWidget {
  @override
  _FirebaseCarouselState createState() => _FirebaseCarouselState();
}

class _FirebaseCarouselState extends State<FirebaseCarousel> {
  List<DocumentSnapshot> carouselData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('carouselData')
        .get();

    setState(() {
      carouselData = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: carouselData.map((document) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              child: Column(
                children: [
                  Image.network(
                    document['imgeurl'],
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 210,
        autoPlay: true,
        autoPlayCurve: Curves.linearToEaseOut,
        enableInfiniteScroll: true,


      ),
    );
  }
}
