import 'package:Ghorbeh/widgets/catigoryList.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Ghorbeh/widgets/drawer.dart';
import '../adminPanel/Orders.dart';
import '../widgets/carousel_slied.dart';
import '../widgets/homeBookCard.dart';
import 'bookdetails.dart';
import 'cart.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          drawer: const drawer(),
          appBar: AppBar(
            title: const Text("Home"),
            backgroundColor: Colors.blueGrey[300],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.blueGrey[50],
                      margin: const EdgeInsets.all(10),
                      elevation: 0,
                      child: Center(
                          child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Icon(Icons.search),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Search for your books",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      )),
                    )),
                const SizedBox(
                  height: 5,
                ),
                FirebaseCarousel(),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: categoryList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Regular Books",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 370, child: HomeBookCard()),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Pop Screen Disabled. You cannot go to previous screen.'),
            backgroundColor: Colors.grey,
          ),
        );
        return false;
      },
    );
  }
}
